# 🎨 RPG Character Generation Prompts

เอกสารรวม Prompt สำหรับการสร้างรูปภาพตัวละครในเกม ทั้ง NPC และตัวละครหลัก (Heroes) โดยใช้ AI สไตล์ Fantasy Anime RPG

---

## 🎭 1. รายการตัวละคร NPC (Required)

วางไฟล์ไว้ที่: `res://Assets/`

| NPC Name | ไฟล์ที่ต้องตั้ง | Prompt สำหรับ AI |
| :--- | :--- | :--- |
| **Merchant Fortune** | `npc_merchant.png` | `A jolly Thai merchant, colorful silk clothes, gold jewelry, holding gold pouch, fantasy RPG anime style, isolated white background` |
| **Guide Path** | `npc_guide.png` | `A friendly Thai youth guide, travel gear with Pha Khao Ma accent, holding a map, fantasy RPG anime style, isolated white background` |
| **Healer Compassion** | `npc_healer.png` | `A compassionate Thai female healer, soft white and teal robes, holding a medicinal bowl, gentle expression, fantasy RPG anime style, isolated white background` |
| **Rival Ambitious** | `npc_rival.png` | `A fierce Thai youth rival, dark martial arts attire, holding dual daggers, cocky expression, fantasy RPG anime style, isolated white background` |
| **Scholar Knowledge** | `npc_scholar.png` | `A studious Thai scholar, scholarly silk robes, holding an ancient scroll, wearing glasses, fantasy RPG anime style, isolated white background` |
| **Storyteller Tales** | `npc_storyteller.png` | `A wise Thai storyteller, robes with heart and star symbols, holding a glowing lantern, fantasy RPG anime style, isolated white background` |
| **Potion Merchant** | `npc_potion_merchant.png` | `An eccentric Thai alchemist, lab coat with Thai patterns, many potion bottles, bubbling beaker, fantasy RPG anime style, isolated white background` |
| **Quest Master** | `npc_questmaster.png` | `A commanding Thai quest master, ornate gold and blue Thai armor, holding a decorative scroll, fantasy RPG anime style, isolated white background` |
| **Guardian Spirit** | `npc_guardian.png` | `A translucent Thai guardian spirit, ethereal nature robes, glowing green accents, peaceful expression, fantasy RPG anime style, isolated white background` |

---

## ⚔️ 2. รายการตัวละครหลัก (Heroes)

วางไฟล์ไว้ที่: `res://Assets/`

### 🛡️ อาชีพ: อัศวิน (Knight - พลังกาย)
| ชื่อ | ไฟล์ที่ต้องตั้ง | Prompt สำหรับ AI |
| :--- | :--- | :--- |
| **แทน (Tan)** | `Tan.png` | `A brave young Thai boy knight, wearing silver and blue light armor, energetic pose, athletic build, holding a wooden practice sword, vibrant anime style, clean lines, RPG character asset, white background` |
| **ริน (Rin)** | `Rin.png` | `A determined young Thai girl knight, light silver armor with blue fabric accents, ponytail hair, holding a small shield and sword, athletic and fit, vibrant anime style, clean lines, RPG character asset, white background` |

### 🧙‍♂️ อาชีพ: จอมเวทย์ (Mage - โภชนาการ)
| ชื่อ | ไฟล์ที่ต้องตั้ง | Prompt สำหรับ AI |
| :--- | :--- | :--- |
| **ปั้น (Pun)** | `Pun.png` | `A smart young Thai boy mage, robes in green and orange (fruit colors), holding a staff topped with a glowing apple-shaped gem, vibrant and healthy look, anime style, clean lines, RPG character asset, white background` |
| **แป้ง (Paeng)** | `Paeng.png` | `A cheerful young Thai girl mage, wearing a wizard hat with herb patterns, robes with fruit and vegetable motifs, holding a sparkling cookbook, vibrant anime style, clean lines, RPG character asset, white background` |

### 🏹 อาชีพ: นักล่า (Scout - สุขอนามัย)
| ชื่อ | ไฟล์ที่ต้องตั้ง | Prompt สำหรับ AI |
| :--- | :--- | :--- |
| **วิน (Win)** | `Win.png` | `A clean-cut young Thai boy scout, wearing light scouting gear in white and sky blue, holding a bow, alert expression, looks fresh and hygienic, vibrant anime style, clean lines, RPG character asset, white background` |
| **พั้นช์ (Punch)** | `Punch.png` | `A sharp-eyed young Thai girl scout, white and light blue travel clothes, utility belt with soap and water flasks, holding a short bow, vibrant anime style, clean lines, RPG character asset, white background` |

### ✨ อาชีพ: ผู้พิทักษ์ (Guardian - จิตใจ)
| ชื่อ | ไฟล์ที่ต้องตั้ง | Prompt สำหรับ AI |
| :--- | :--- | :--- |
| **กร (Korn)** | `Korn.png` | `A calm young Thai boy guardian, wearing white and lavender flowing robes with gold trim, peaceful expression, hands in a meditative pose or holding a glowing charm, anime style, clean lines, RPG character asset, white background` |
| **ฟ้า (Fah)** | `Fan.png` | `A serene young Thai girl guardian, long flowing white hair or ribbon, robes in soft purple and white, empathetic expression, surrounded by floating heart or light particles, anime style, clean lines, RPG character asset, white background` |

---

## 💡 เทคนิคเพิ่มเติม (Tips)
- **Background:** ทุก Prompt ระบุ `white background` เพื่อให้ง่ายต่อการตัดพื้นหลังออก (Remove Background)
- **Style:** หากต้องการเปลี่ยนสไตล์ สามารถแก้คำว่า `vibrant anime style` เป็นสไตล์อื่นที่ต้องการได้ (เช่น `3D render style`, `pixel art style`)
- **Transparency:** เมื่อนำไฟล์เข้า Godot แนะนำให้ใช้ไฟล์นามสกุล `.png` ที่ไม่มีพื้นหลัง เพื่อความสวยงามในเกมครับ
