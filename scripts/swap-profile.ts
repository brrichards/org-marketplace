/// <reference types="node" />

import { readFile, mkdir, rm, cp, readdir, stat } from "fs/promises";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

// #region Constants

const scriptDir = dirname(fileURLToPath(import.meta.url));
const root = join(scriptDir, "..");
const profilesDir = join(root, "profiles");

// #endregion

// #region Interfaces

/**
 * A profile's settings.json structure.
 *
 * @remarks
 * Uses the native Claude Code settings format. The `extraKnownMarketplaces`
 * field registers marketplaces, and `enabledPlugins` is a boolean map
 * of `"plugin@marketplace": true/false`. Claude Code handles marketplace
 * registration and plugin installation automatically when the user
 * trusts the project folder.
 */
interface ProfileSettings {
  extraKnownMarketplaces?: Record<
    string,
    { source: { source: string; repo?: string; url?: string } }
  >;
  enabledPlugins?: Record<string, boolean>;
  permissions?: {
    deny?: string[];
    allow?: string[];
  };
}

// #endregion

// #region Helpers

/**
 * Checks whether a directory exists and contains a settings.json file.
 *
 * @param dirPath - Absolute path to the candidate profile directory.
 * @returns True if the directory contains a settings.json.
 */
async function isProfileDir(dirPath: string): Promise<boolean> {
  try {
    const s = await stat(join(dirPath, "settings.json"));
    return s.isFile();
  } catch {
    return false;
  }
}

/**
 * Discovers all valid profile names by scanning the profiles directory.
 *
 * @returns Sorted array of profile directory names.
 */
async function discoverProfiles(): Promise<string[]> {
  const entries = await readdir(profilesDir, { withFileTypes: true });
  const profiles: string[] = [];

  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    if (await isProfileDir(join(profilesDir, entry.name))) {
      profiles.push(entry.name);
    }
  }

  return profiles.sort();
}

/**
 * Loads and parses a profile's settings.json.
 *
 * @param name - The profile name (subdirectory under profiles/).
 * @returns The parsed profile settings.
 */
async function loadProfileSettings(name: string): Promise<ProfileSettings> {
  const settingsPath = join(profilesDir, name, "settings.json");
  const data = await readFile(settingsPath, "utf-8");
  return JSON.parse(data) as ProfileSettings;
}

/**
 * Returns the list of enabled plugin keys from a profile's settings.
 *
 * @param settings - The parsed profile settings.
 * @returns Array of "plugin@marketplace" strings that are set to true.
 */
function getEnabledPlugins(settings: ProfileSettings): string[] {
  if (!settings.enabledPlugins) return [];
  return Object.entries(settings.enabledPlugins)
    .filter(([, enabled]) => enabled)
    .map(([name]) => name);
}

// #endregion

// #region Subcommands

/**
 * Lists all available profiles with their plugin counts.
 *
 * @remarks
 * Scans the profiles/ directory for subdirectories containing settings.json.
 * Displays a table with profile name, enabled plugin count, and plugins.
 */
async function cmdList(): Promise<void> {
  const profiles = await discoverProfiles();

  if (profiles.length === 0) {
    console.log("No profiles found in profiles/");
    return;
  }

  console.log("Available Profiles:\n");
  console.log(
    "  " +
      "Profile".padEnd(20) +
      "Plugins".padEnd(10) +
      "Enabled",
  );
  console.log("  " + "-".repeat(50));

  for (const name of profiles) {
    try {
      const settings = await loadProfileSettings(name);
      const enabled = getEnabledPlugins(settings);
      const count = enabled.length;
      const plugins = count === 0 ? "(none)" : enabled.join(", ");
      console.log(
        "  " +
          name.padEnd(20) +
          String(count).padEnd(10) +
          plugins,
      );
    } catch {
      console.log("  " + name.padEnd(20) + "?".padEnd(10) + "(error reading)");
    }
  }

  console.log();
}

/**
 * Swaps a target project to the specified profile.
 *
 * @param name - The profile name to activate.
 * @param target - The target project directory (defaults to cwd).
 *
 * @remarks
 * 1. Validates the profile exists
 * 2. Removes the target's .claude/ directory
 * 3. Copies the entire profile directory as the new .claude/
 *
 * Claude Code reads `extraKnownMarketplaces` and `enabledPlugins` from
 * the copied settings.json natively — it prompts the user to install
 * marketplaces and plugins when they trust the project folder.
 */
async function cmdSwap(name: string, target: string): Promise<void> {
  // Validate profile exists
  const profiles = await discoverProfiles();
  if (!profiles.includes(name)) {
    console.error(`Error: Profile "${name}" not found.`);
    console.error(`Available profiles: ${profiles.join(", ")}`);
    process.exit(1);
  }

  // Read profile settings for summary
  const settings = await loadProfileSettings(name);
  const enabled = getEnabledPlugins(settings);

  // Remove existing .claude/ directory
  const targetClaudeDir = join(target, ".claude");
  try {
    await rm(targetClaudeDir, { recursive: true, force: true });
  } catch {
    // Directory may not exist — safe to ignore
  }

  // Copy entire profile directory as .claude/
  const profileDir = join(profilesDir, name);
  await cp(profileDir, targetClaudeDir, { recursive: true });
  console.log(`Copied profile "${name}" -> ${targetClaudeDir}`);

  // Summary
  console.log(`\nProfile "${name}" applied to ${target}`);
  if (enabled.length > 0) {
    console.log(`Enabled plugins: ${enabled.join(", ")}`);
  } else {
    console.log("No plugins enabled.");
  }
}

/**
 * Prints usage information.
 */
function cmdHelp(): void {
  console.log("Usage: swap-profile.ts <command> [args]\n");
  console.log("Commands:");
  console.log("  list                    List available profiles");
  console.log("  swap <name> [target]    Apply a profile to a target directory");
  console.log("  help                    Show this help message\n");
  console.log("Arguments:");
  console.log("  name      Profile name (subdirectory under profiles/)");
  console.log("  target    Target project directory (defaults to current directory)\n");
  console.log("Examples:");
  console.log("  npx tsx scripts/swap-profile.ts list");
  console.log("  npx tsx scripts/swap-profile.ts swap default /path/to/project");
  console.log("  npx tsx scripts/swap-profile.ts swap example-full");
}

// #endregion

// #region Main

/**
 * Parses CLI arguments and dispatches to the appropriate subcommand.
 *
 * @remarks
 * Defaults to `list` when no subcommand is provided. Prints usage
 * information and exits with code 1 for unknown commands.
 */
async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const command = args[0] || "list";

  switch (command) {
    case "list": {
      await cmdList();
      break;
    }

    case "swap": {
      const name = args[1];
      if (!name) {
        console.error("Usage: swap-profile.ts swap <name> [target]");
        process.exit(1);
      }
      const target = args[2] || process.cwd();
      await cmdSwap(name, target);
      break;
    }

    case "help": {
      cmdHelp();
      break;
    }

    default: {
      console.error(`Unknown command: ${command}`);
      console.error("Usage: swap-profile.ts <list|swap|help>");
      console.error("  list                    List available profiles");
      console.error("  swap <name> [target]    Apply a profile to a target");
      console.error("  help                    Show usage information");
      process.exit(1);
    }
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});

// #endregion
