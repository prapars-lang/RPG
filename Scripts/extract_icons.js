/**
 * Extract individual item icons from RPG Maker MZ IconSet.png
 * IconSet.png is a grid of 32x32 pixel icons, 16 columns wide.
 * Each icon is identified by its index (row * 16 + col).
 */
const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

const ICON_SIZE = 32;
const COLS = 16;
const OUTPUT_SIZE = 64; // Scale up for Godot visibility
const INPUT = path.join(__dirname, '..', 'Assets', 'img', 'system', 'IconSet.png');
const OUTPUT_DIR = path.join(__dirname, '..', 'Assets', 'items');

// Icon index -> filename mapping (RPG Maker MZ standard positions)
const ICONS = {
    // === Weapons ===
    96: 'sword_iron',
    97: 'sword_steel',
    98: 'sword_mythril',
    99: 'axe_battle',
    100: 'spear_iron',
    101: 'bow_short',
    102: 'bow_long',
    103: 'staff_oak',
    104: 'staff_mystic',
    105: 'dagger_iron',
    106: 'dagger_assassin',
    107: 'whip',
    108: 'claw',
    110: 'sword_flame',
    111: 'sword_ice',

    // === Shields ===
    128: 'shield_wooden',
    129: 'shield_iron',
    130: 'shield_mythril',
    131: 'shield_tower',

    // === Head Armor ===
    132: 'helm_leather',
    133: 'helm_iron',
    134: 'helm_knight',
    135: 'hat_wizard',
    136: 'crown_golden',
    137: 'bandana',

    // === Body Armor ===
    138: 'armor_leather',
    139: 'armor_chainmail',
    140: 'armor_plate',
    141: 'robe_silk',
    142: 'robe_mystic',
    143: 'cloak_shadow',

    // === Gloves ===
    144: 'gloves_leather',
    145: 'gloves_iron',
    146: 'gloves_mythril',

    // === Boots ===
    147: 'boots_leather',
    148: 'boots_iron',
    149: 'boots_speed',

    // === Accessories ===
    150: 'ring_power',
    151: 'ring_guard',
    152: 'ring_magic',
    153: 'necklace_hp',
    154: 'necklace_mp',
    155: 'amulet_luck',
    156: 'belt_strength',
    157: 'cape_wind',

    // === Consumables ===
    176: 'potion_hp',
    177: 'potion_mp',
    178: 'potion_hp_large',
    179: 'potion_mp_large',

    // === Orbs / Gems ===
    160: 'orb_fire',
    161: 'orb_ice',
    162: 'orb_thunder',
    163: 'orb_earth',
    164: 'orb_light',
    165: 'orb_dark',
};

async function main() {
    if (!fs.existsSync(OUTPUT_DIR)) {
        fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }

    const metadata = await sharp(INPUT).metadata();
    console.log(`IconSet.png: ${metadata.width}x${metadata.height}`);
    console.log(`Grid: ${metadata.width / ICON_SIZE} cols x ${metadata.height / ICON_SIZE} rows`);

    let count = 0;
    for (const [idxStr, name] of Object.entries(ICONS)) {
        const idx = parseInt(idxStr);
        const row = Math.floor(idx / COLS);
        const col = idx % COLS;
        const x = col * ICON_SIZE;
        const y = row * ICON_SIZE;

        if (x + ICON_SIZE > metadata.width || y + ICON_SIZE > metadata.height) {
            console.log(`  SKIP ${name} (idx ${idx}): out of bounds`);
            continue;
        }

        const outPath = path.join(OUTPUT_DIR, `${name}.png`);
        await sharp(INPUT)
            .extract({ left: x, top: y, width: ICON_SIZE, height: ICON_SIZE })
            .resize(OUTPUT_SIZE, OUTPUT_SIZE, { kernel: 'nearest' })
            .toFile(outPath);

        count++;
        console.log(`  OK: ${name}.png (idx ${idx})`);
    }

    console.log(`\nDone! Extracted ${count} icons to ${OUTPUT_DIR}`);
}

main().catch(console.error);
