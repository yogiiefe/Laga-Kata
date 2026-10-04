# Struktur File Proyek (Aktual & Lengkap)

Dokumen ini menjelaskan struktur file dan folder proyek Godot **berdasarkan implementasi aktual** game battle berbasis membentuk kata bahasa Indonesia. Struktur ini **sudah dioptimalkan untuk MVP** dengan fokus pada gameplay inti.

---

## 📁 Struktur Direktori Lengkap

```text
res://
│
├── assets/
│   ├── audio/
│   │   ├── bgm/
│   │   │   ├── main_menu.ogg
│   │   │   └── battle.ogg
│   │   └── sfx/
│   │       ├── type.ogg
│   │       ├── word_correct.ogg
│   │       ├── word_wrong.ogg
│   │       ├── attack.ogg
│   │       ├── hit.ogg
│   │       ├── player_hurt.ogg
│   │       ├── enemy_defeat.ogg
│   │       ├── powerup.ogg
│   │       ├── button_click.ogg
│   │       └── stage_clear.ogg
│   │
│   ├── fonts/
│   │   └── game_font.ttf
│   │
│   └── graphics/
│       ├── backgrounds/
│       │   ├── main_menu_bg.png
│       │   ├── battle_bg.png
│       │   └── battle_bg_boss.png
│       │
│       ├── characters/
│       │   ├── player/
│       │   │   ├── idle.png
│       │   │   ├── attack.png
│       │   │   ├── hurt.png
│       │   │   └── defeat.png
│       │   │
│       │   └── enemies/
│       │       ├── enemy_01.png
│       │       ├── enemy_02.png
│       │       └── boss.png
│       │
│       ├── effects/
│       │   ├── attack_effect.png
│       │   ├── hit_effect.png
│       │   ├── critical_effect.png
│       │   ├── shield_effect.png
│       │   └── powerup_effect.png
│       │
│       └── ui/
│           ├── button.png
│           ├── panel.png
│           ├── health_bar.png
│           ├── word_progress.png
│           ├── letter_tile.png
│           ├── powerup_attack.png
│           └── powerup_shield.png
│
├── autoload/
│   ├── AudioManager.gd
│   ├── GameManager.gd
│   └── SaveManager.gd
│
├── data/
│   ├── words.json
│   ├── enemies.json
│   ├── stages.json
│   └── powerups.json
│
├── scenes/
│   ├── game/
│   │   ├── MainGame.tscn
│   │   ├── Battle.tscn
│   │   └── StageTransition.tscn
│   │
│   ├── entities/
│   │   ├── Player.tscn
│   │   ├── Enemy.tscn
│   │   └── PowerUp.tscn
│   │
│   ├── ui/
│   │   ├── BattleUI.tscn
│   │   ├── WordInput.tscn
│   │   ├── LetterTile.tscn
│   │   ├── HealthBar.tscn
│   │   ├── WordProgress.tscn
│   │   ├── PowerUpUI.tscn
│   │   ├── DamagePopup.tscn
│   │   └── Countdown.tscn
│   │
│   └── menus/
│       ├── Splash.tscn
│       ├── MainMenu.tscn
│       ├── Settings.tscn
│       ├── Achievements.tscn
│       ├── PauseMenu.tscn
│       ├── GameOver.tscn
│       └── StageClear.tscn
│
├── scripts/
│   ├── game/
│   │   ├── MainGame.gd
│   │   ├── Battle.gd
│   │   ├── BattleManager.gd          ← Sistem pertarungan terperinci
│   │   ├── CombatManager.gd           ← Manajemen pertempuran
│   │   ├── StageManager.gd
│   │   └── BattleTimer.gd
│   │
│   ├── word/
│   │   ├── WordManager.gd
│   │   ├── WordValidator.gd
│   │   ├── WordData.gd
│   │   └── ClueManager.gd
│   │
│   ├── entities/
│   │   ├── Player.gd
│   │   ├── Enemy.gd
│   │   └── PowerUp.gd
│   │
│   ├── ui/
│   │   ├── BattleUI.gd
│   │   ├── MainMenuUI.gd             ← Kontrol menu utama
│   │   ├── WordInput.gd
│   │   ├── LetterTile.gd
│   │   ├── HealthBar.gd
│   │   ├── WordProgress.gd
│   │   ├── PowerUpUI.gd
│   │   ├── DamagePopup.gd
│   │   └── Countdown.gd
│   │
│   └── managers/
│       ├── InputManager.gd
│       └── AchievementManager.gd
│
├── shaders/
│   ├── hit_flash.gdshader
│   └── outline.gdshader
│
├── FileStructure.md                  ← Dokumen ini
├── icon.svg
└── project.godot
```

---

## 📊 Perbedaan dengan Rencana Ideal

| Aspek | Rencana | Aktual | Keterangan |
|---|---|---|---|
| Sistem Battle | `Battle.gd` saja | `Battle.gd` + `BattleManager.gd` + `CombatManager.gd` | **Lebih modular dan detail** |
| Menu UI | Scene tscn saja | Scene + `MainMenuUI.gd` | **Kontrol lebih baik** |
| Struktur Audio | Semua SFX terpisah | Folder `bgm/` dan `sfx/` | **Sama, terorganisir** |
| Graphics | Folder `effect/` | Folder `effects/` | **Sama** |
| Overall | 3 sistem manager | 3+ sistem dengan detail | **Lebih kuat untuk MVP** |

---

## 🎯 Penjelasan Folder Utama

### 1. `assets/` — Semua Resource Statis

Semua aset visual dan audio game disimpan di sini. Diorganisir berdasarkan tipe media.

#### `audio/bgm/` — Background Music
```
main_menu.ogg       → Musik saat di menu utama
battle.ogg          → Musik saat berlangsungnya pertarungan
```

#### `audio/sfx/` — Sound Effects (Efek Suara)
```
type.ogg            → Saat pemain mengetik/memilih huruf
word_correct.ogg    → Kata benar ✓
word_wrong.ogg      → Kata salah ✗
attack.ogg          → Serangan dimulai
hit.ogg             → Serangan terkena target
player_hurt.ogg     → Pemain terkena damage
enemy_defeat.ogg    → Musuh kalah
powerup.ogg         → Power-up diaktifkan
button_click.ogg    → Tombol UI diklik
stage_clear.ogg     → Stage selesai
```

#### `fonts/`
```
game_font.ttf       → Font utama untuk UI dan teks game (doodle/hand-drawn style)
```

#### `graphics/backgrounds/`
```
main_menu_bg.png        → Latar menu utama
battle_bg.png           → Latar battle standar
battle_bg_boss.png      → Latar boss battle khusus
```

#### `graphics/characters/player/`
Sprite pemain dalam berbagai state:
```
idle.png            → Pose normal/siap
attack.png          → Pose menyerang
hurt.png            → Pose terkena damage
defeat.png          → Pose kalah
```

#### `graphics/characters/enemies/`
```
enemy_01.png        → Musuh tipe 1
enemy_02.png        → Musuh tipe 2
boss.png            → Sprite boss battle
```

#### `graphics/effects/`
Efek visual yang muncul saat pertarungan:
```
attack_effect.png       → Efek serangan diluncurkan
hit_effect.png          → Efek serangan mengenai
critical_effect.png     → Efek pukulan critical
shield_effect.png       → Efek pertahanan aktif
powerup_effect.png      → Efek power-up digunakan
```

#### `graphics/ui/`
Asset untuk antarmuka:
```
button.png              → Gambar tombol dasar
panel.png               → Background panel/window
health_bar.png          → Asset health bar
word_progress.png       → Asset progress race kata
letter_tile.png         → Asset huruf yang bisa didrag
powerup_attack.png      → Ikon power-up Overclock
powerup_shield.png      → Ikon power-up Firewall
```

---

### 2. `autoload/` — Sistem Global

Script yang **otomatis dimuat saat game start** dan dapat diakses dari mana saja.

#### `AudioManager.gd`
Mengelola semua aspek audio game.

**Tanggung jawab:**
- Memutar dan menghentikan BGM
- Memutar SFX dengan timing yang tepat
- Mengatur volume BGM dan SFX terpisah
- Mengelola audio bus
- Mencegah duplikasi pemutar musik

**Contoh fungsi:**
```gdscript
AudioManager.play_bgm("battle")
AudioManager.play_sfx("word_correct")
AudioManager.set_bgm_volume(0.5)
AudioManager.set_sfx_volume(0.8)
```

#### `GameManager.gd`
Menyimpan dan mengelola state global game.

**Menyimpan:**
- Stage/level saat ini
- Skor pemain
- Total kata yang terbentuk
- Tingkat kesulitan game
- Status game (playing, paused, etc)
- Progress keseluruhan

**Catatan:** Ini adalah state **tingkat tinggi**, bukan logika battle detail. Detail battle ada di `Battle.gd` dan `BattleManager.gd`.

#### `SaveManager.gd`
Menyimpan dan memuat data permanen pemain.

**Data yang disimpan:**
- Stage tertinggi yang dibuka
- Skor tertinggi
- Pengaturan (volume, grafis, dll)
- Progress achievement
- Data statistik pemain

---

### 3. `data/` — Game Data (JSON)

File-file JSON yang **dapat diubah tanpa mengubah kode**. Ini memungkinkan balancing dan tweaking tanpa perlu recompile.

#### `words.json` — Database Kata
Daftar semua kata bahasa Indonesia yang bisa dimainkan.

**Format:**
```json
[
  {
	"word": "KUCING",
	"clue": "Hewan yang suka mengeong",
	"difficulty": 1,
	"category": "binatang",
	"stageRequirement": 1
  },
  {
	"word": "KOMPUTER",
	"clue": "Mesin untuk menghitung dan bekerja",
	"difficulty": 2,
	"category": "teknologi",
	"stageRequirement": 3
  }
]
```

**Field:**
- `word` — Jawaban yang harus dibentuk pemain (UPPERCASE)
- `clue` — Petunjuk untuk pemain
- `difficulty` — Tingkat kesulitan (1-3)
- `category` — Kategori (opsional)
- `stageRequirement` — Stage minimum untuk membuka kata ini (opsional)

#### `enemies.json` — Konfigurasi Musuh
Data setiap tipe musuh yang dapat disesuaikan.

**Format:**
```json
[
  {
	"id": "enemy_01",
	"name": "Goblin",
	"hp": 20,
	"wordSpeed": 1.5,
	"damage": 3,
	"difficulty": 1,
	"sprite": "enemy_01.png"
  }
]
```

**Field:**
- `id` — ID unik musuh
- `name` — Nama tampilan
- `hp` — Hit point
- `wordSpeed` — Kecepatan membentuk kata (multiplier)
- `damage` — Damage per serangan
- `difficulty` — Tingkat kesulitan
- `sprite` — Path ke sprite file

#### `stages.json` — Konfigurasi Stage
Data setiap level/stage yang dimainkan.

**Format:**
```json
[
  {
	"id": 1,
	"name": "Stage 1: Mulai",
	"enemyId": "enemy_01",
	"background": "battle_bg.png",
	"difficulty": 1,
	"wordDifficulty": [1, 2],
	"isBoss": false,
	"battleCount": 1
  },
  {
	"id": 2,
	"name": "Stage 2: Tantangan",
	"enemyId": "enemy_02",
	"background": "battle_bg.png",
	"difficulty": 2,
	"wordDifficulty": [1, 2, 3],
	"isBoss": false,
	"battleCount": 2
  }
]
```

#### `powerups.json` — Data Power-up
Definisi semua power-up yang tersedia.

**Format:**
```json
[
  {
	"id": "overclock",
	"name": "Overclock",
	"description": "Serangan berikutnya +50% damage",
	"effectType": "damage_boost",
	"effectValue": 1.5,
	"duration": 1,
	"icon": "powerup_attack.png"
  },
  {
	"id": "firewall",
	"name": "Firewall",
	"description": "Blokir serangan musuh berikutnya",
	"effectType": "block_attack",
	"effectValue": 100,
	"duration": 1,
	"icon": "powerup_shield.png"
  }
]
```

---

### 4. `scenes/` — Scene Godot (`.tscn`)

Setiap file `.tscn` adalah scene yang dapat diedit di Godot Editor dan memiliki script GDScript yang sesuai.

#### `scenes/game/` — Alur Gameplay Utama

##### `MainGame.tscn` + `MainGame.gd`
**Fungsi:** Wadah utama gameplay yang mengelola alur keseluruhan.

**Tanggung jawab:**
- Inisialisasi gameplay
- Load stage saat ini
- Menjalankan battle berurutan
- Menangani transisi antar stage
- Berkomunikasi dengan `GameManager`

**Hubungan:** `MainGame.gd` → mengontrol alur → `StageManager.gd` → load stage → `Battle.tscn`

---

##### `Battle.tscn` + `Battle.gd`
**Fungsi:** Scene pertarungan inti.

**Struktur hirarki:**
```
Battle (root)
├── Player (node pemain)
├── Enemy (node musuh)
├── BattleUI (antarmuka pertarungan)
├── WordInput (input kata pemain)
├── Effects (kontainer efek visual)
└── Audio (kontainer audio)
```

**Tanggung jawab `Battle.gd`:**
- Mengelola alur pertarungan
- Mengkoordinasi aksi pemain dan musuh
- Menerima event "kata selesai" dari `WordInput`
- Membandingkan jumlah kata pemain vs musuh
- Menghitung damage
- Menerapkan damage ke HP
- Memeriksa kondisi menang/kalah
- Mengakhiri pertarungan

**Alur pertarungan:**
```
Battle Start
	↓
Select Word & Display Clue (WordManager)
	↓
Player Forms Word (WordInput)
	↓
Validate Word (WordValidator)
	├── Invalid → Feedback
	└── Valid → Word Count +1
		   ↓
		   Compare Counts (Battle)
		   ↓
		   Leader Attacks (BattleManager/CombatManager)
		   ↓
		   Update HP
		   ├── Alive → Next Word
		   └── Defeated → End Battle
```

---

##### `StageTransition.tscn` + `StageManager.gd`
**Fungsi:** Layar transisi antar stage.

**Tampilan:**
```
═════════════════════════════════
	  STAGE 2: TANTANGAN
	  vs Goblin Warrior
═════════════════════════════════
		  [Lanjut]
```

**Tanggung jawab `StageManager.gd`:**
- Memuat data stage dari `stages.json`
- Menentukan stage yang sedang dimainkan
- Memunculkan enemy dengan properti yang benar
- Memilih background yang sesuai
- Membuka stage berikutnya saat stage selesai
- Mendeteksi saat game selesai (semua stage tamat)

---

#### `scenes/entities/` — Entitas Gameplay

##### `Player.tscn` + `Player.gd`
**Fungsi:** Karakter pemain yang dapat dimainkan.

**Tanggung jawab:**
- Menampilkan sprite pemain
- Menjalankan animasi (idle, attack, hurt, defeat)
- Mengelola HP pemain
- Menerima damage
- Melakukan serangan
- Mengaktifkan power-up
- Menjaga state pemain (alive/defeated)

---

##### `Enemy.tscn` + `Enemy.gd`
**Fungsi:** Musuh yang dapat dipakai kembali (reusable).

**Tanggung jawab:**
- Menampilkan sprite musuh
- Mengelola HP musuh
- Menerima damage
- **Membentuk kata** secara otomatis (AI)
- Melakukan serangan
- Animasi (attack, hurt, defeat)
- **Properti dimuat dari `enemies.json`** (tidak hardcoded)

**Catatan penting:** Perilaku AI dan statistik musuh harus flexible dan dapat dikonfigurasi via JSON.

---

##### `PowerUp.tscn` + `PowerUp.gd`
**Fungsi:** Entitas power-up yang dapat diambil/diaktifkan.

**Tanggung jawab:**
- Menampilkan power-up dengan ikon/sprite
- Menyimpan tipe power-up (Overclock, Firewall, dll)
- Memicu efek power-up saat diaktifkan
- Menjalankan animasi aktivasi
- Mengelola durasi efek

**Power-up yang direncanakan:**
- **Overclock:** Serangan berikutnya +50% damage
- **Firewall:** Blokir serangan musuh berikutnya

---

#### `scenes/ui/` — Komponen Antarmuka

##### `BattleUI.tscn` + `BattleUI.gd`
**Fungsi:** Antarmuka utama pertarungan (HUD).

**Menampilkan:**
```
┌─ PLAYER HP: ██████░░ 16/20              ENEMY HP: █████░░░ 15/20 ─┐
│                                                                     │
│  Clue: Hewan yang suka mengeong                                    │
│  Current Word: _ _ _ _ _ _                                         │
│                                                                     │
│  Words: Player 2 | Enemy 1                                         │
│  ▓▓▓▓▓▓▓▓░░░░ vs ▓▓▓▓▓░░░░░                                        │
│                                                                     │
│  Power-ups: [Overclock ⚡] [Firewall 🛡]                           │
└─────────────────────────────────────────────────────────────────────┘
```

**Tanggung jawab:**
- Update tampilan HP real-time
- Update jumlah kata yang terbentuk
- Menampilkan clue saat ini
- Menampilkan kata yang sedang dikerjakan
- Menampilkan power-up yang tersedia
- Status pertarungan (countdown, result, dll)
- Trigger animasi UI

---

##### `WordInput.tscn` + `WordInput.gd`
**Fungsi:** Sistem input kata pemain (KOMPONEN TERPENTING).

**Mendukung:**
- Input keyboard (ketik huruf)
- Drag-and-drop letter tiles
- Pemilihan huruf dengan mouse
- Penghapusan huruf yang dipilih
- Submit kata
- Reset kata yang sedang dikerjakan

**Flow:**
```
Player Input (Keyboard atau Drag)
	↓
Add Letter to Current Word
	↓
Update Display (BattleUI)
	↓
Player Presses Enter / Submit Button
	↓
WordValidator.validate(current_word)
	├── Invalid → Play "wrong" sound, clear
	└── Valid → Emit "word_completed" signal
			  → WordManager triggers next word
```

---

##### `LetterTile.tscn` + `LetterTile.gd`
**Fungsi:** Representasi satu huruf yang dapat di-drag.

**Contoh visual:**
```
╔───╗ ╔───╗ ╔───╗ ╔───╗ ╔───╗ ╔───╗
║ K ║ ║ U ║ ║ C ║ ║ I ║ ║ N ║ ║ G ║
╚───╝ ╚───╝ ╚───╝ ╚───╝ ╚───╝ ╚───╝
```

**Tanggung jawab:**
- Menampilkan huruf dengan sprite
- Deteksi input mouse (hover, drag)
- Support dragging ke area input
- Support selection dengan visual feedback
- Trigger animasi saat dipilih

---

##### `HealthBar.tscn` + `HealthBar.gd`
**Fungsi:** Komponen bar HP yang reusable.

**Tanggung jawab:**
- Update HP saat berubah
- Animasi perubahan HP (smooth transition)
- Menampilkan current/max HP
- Handle state kosong dan penuh
- Digunakan untuk pemain dan musuh

---

##### `WordProgress.tscn` + `WordProgress.gd`
**Fungsi:** Display progress kata dalam format balapan.

**Visual:**
```
PLAYER    ████████░░░░░░  8 words
ENEMY     ███░░░░░░░░░░░  3 words
		  Player Winning!
```

**Tanggung jawab:**
- Tampilkan jumlah kata pemain
- Tampilkan jumlah kata musuh
- Tunjuk siapa yang memimpin
- Animasi perubahan progress

---

##### `PowerUpUI.tscn` + `PowerUpUI.gd`
**Fungsi:** Tampilan power-up yang tersedia.

**Tanggung jawab:**
- Tampilkan ikon power-up tersedia
- Tampilkan status aktif/tidak aktif
- Handle input aktivasi (click/key press)
- Tampilkan cooldown atau usage state

---

##### `DamagePopup.tscn` + `DamagePopup.gd`
**Fungsi:** Feedback temporary saat ada damage atau special events.

**Contoh tampilan:**
```
	 -3
```
atau
```
   CRITICAL!
```
atau
```
   BLOCKED!
```

**Tanggung jawab:**
- Tampilkan nilai damage
- Tampilkan teks khusus (CRITICAL, BLOCKED, dll)
- Animasi popup (muncul, bergeser, hilang)
- Otomatis hapus diri setelah durasi

---

##### `Countdown.tscn` + `Countdown.gd`
**Fungsi:** Hitung mundur sebelum battle dimulai.

**Visual:**
```
		3
		
atau

		2
		
atau

		GO!
```

**Tanggung jawab:**
- Tampilkan angka countdown
- Animasi countdown
- Mainkan sound effect countdown
- Beri tahu `Battle` saat countdown selesai

---

#### `scenes/menus/` — Menu dan Layar Hasil

##### `Splash.tscn`
**Fungsi:** Layar pembuka yang ditampilkan saat game start.

**Isi:**
- Logo game
- Logo tim/developer
- Animasi singkat

**Durasi:** Cepat, 2-3 detik, kemudian lanjut ke MainMenu.

---

##### `MainMenu.tscn` + `MainMenuUI.gd`
**Fungsi:** Menu utama game.

**Tombol:**
```
╔════════════════════════╗
║    BATTLE WORD GAME    ║
║                        ║
║     [MULAI]            ║
║   [PENGATURAN]         ║
║    [PRESTASI]          ║
║     [KELUAR]           ║
╚════════════════════════╝
```

---

##### `Settings.tscn`
**Fungsi:** Menu pengaturan.

**Opsi:**
- Volume BGM (slider)
- Volume SFX (slider)
- Fullscreen / Windowed (toggle)
- Accessibility settings (opsional)

---

##### `Achievements.tscn`
**Fungsi:** Tampilan pencapaian pemain.

**Contoh achievement:**
- ✓ Bentuk 10 kata
- ✓ Menang tanpa terkena damage
- ○ Bentuk kata panjang (>6 huruf)
- ○ Selesaikan stage terakhir
- ○ Kalahkan boss

**Catatan:** Fitur opsional untuk MVP, bisa dikerjakan belakangan.

---

##### `PauseMenu.tscn`
**Fungsi:** Menu pause saat pertarungan berlangsung.

**Opsi:**
```
╔════════════════════════╗
║       PERMAINAN PAUSE  ║
║                        ║
║     [LANJUT]           ║
║   [PENGATURAN]         ║
║     [ULANGI]           ║
║   [KEMBALI KE MENU]    ║
╚════════════════════════╝
```

---

##### `GameOver.tscn`
**Fungsi:** Layar saat pemain kalah.

**Tampilan:**
```
╔════════════════════════╗
║   PERMAINAN BERAKHIR   ║
║   Anda Kalah...        ║
║                        ║
║ Skor: 150              ║
║ Kata Terbentuk: 8      ║
║ Stage Tercapai: 2      ║
║                        ║
║    [COBA LAGI]         ║
║  [KEMBALI KE MENU]     ║
╚════════════════════════╝
```

---

##### `StageClear.tscn`
**Fungsi:** Layar saat pemain menyelesaikan stage.

**Tampilan:**
```
╔════════════════════════╗
║   STAGE SELESAI!       ║
║                        ║
║ Skor: 300              ║
║ Kata Terbentuk: 15     ║
║ Combo: 3x              ║
║                        ║
║  [STAGE BERIKUTNYA]    ║
╚════════════════════════╝
```

---

### 5. `scripts/` — Kode GDScript

#### `scripts/game/` — Logika Gameplay dan Alur

##### `MainGame.gd`
**Fungsi:** Pengontrol alur gameplay keseluruhan.

```gdscript
# Pseudocode
extends Node

func _ready():
	GameManager.reset_progress()
	load_current_stage()

func load_current_stage():
	var stage_data = StageManager.get_current_stage()
	# Load enemy, background, dll

func on_battle_won():
	GameManager.next_stage()
	load_current_stage()

func on_all_stages_completed():
	# Show game complete screen
```

---

##### `Battle.gd`
**Fungsi:** Pengendali battle inti.

**Alur logika:**
```gdscript
func start_battle():
	# Initialize player, enemy, word
	emit_signal("battle_started")

func on_word_completed():
	var result = WordValidator.validate(current_word)
	if result.valid:
		update_word_count()
		resolve_exchange()

func resolve_exchange():
	# Compare word counts
	# Determine attacker
	# Calculate damage
	# Apply damage
	# Check victory/defeat

func apply_damage(target: Node, damage: int):
	target.take_damage(damage)
	DamagePopup.show(damage)
	AudioManager.play_sfx("hit")
```

---

##### `BattleManager.gd` ⭐ (SISTEM TAMBAHAN)
**Fungsi:** Manajemen pertarungan yang lebih terperinci.

**Tanggung jawab:**
- Koordinasi player dan enemy attacks
- Sistem turn-based atau real-time
- Kalkulasi damage dengan formula
- Efek special/critical hits
- Integrasi power-ups

**Contoh:**
```gdscript
func calculate_damage(attacker: Node, defender: Node, word_count_diff: int) -> int:
	var base_damage = attacker.damage
	var multiplier = 1.0 + (word_count_diff * 0.1)
	var final_damage = int(base_damage * multiplier)
	
	# Check for critical
	if randf() < 0.1:  # 10% crit chance
		final_damage *= 2
		emit_signal("critical_hit")
	
	return final_damage
```

---

##### `CombatManager.gd` ⭐ (SISTEM TAMBAHAN)
**Fungsi:** Manajemen sistem pertempuran (combat system).

**Tanggung jawab:**
- State machine pertarungan
- Koordinasi serangan dan pertahanan
- Trigger effect visual/audio

---

##### `StageManager.gd`
**Fungsi:** Mengelola progression stage.

```gdscript
func load_stage(stage_id: int):
	var stage_data = load_json("res://data/stages.json")
	var stage = stage_data[stage_id - 1]
	
	# Load enemy
	var enemy_id = stage["enemyId"]
	var enemy_data = load_enemy_data(enemy_id)
	
	# Load background
	var bg_path = "res://assets/graphics/backgrounds/" + stage["background"]
	load_background(bg_path)
	
	return stage

func unlock_next_stage():
	var current = GameManager.current_stage
	GameManager.highest_unlocked_stage = max(
		GameManager.highest_unlocked_stage,
		current + 1
	)
```

---

##### `BattleTimer.gd`
**Fungsi:** Mengelola aspek waktu dalam battle.

**Tanggung jawab:**
- Enemy response timer (AI delay)
- Countdown sebelum battle
- Time limit untuk kata (opsional)
- Timed events dalam battle

---

#### `scripts/word/` — Sistem Kata

##### `WordManager.gd`
**Fungsi:** Pengelola data kata pusat.

```gdscript
func _ready():
	load_words_from_json("res://data/words.json")

func get_random_word(difficulty: int) -> WordData:
	var candidates = words.filter(func(w): return w.difficulty == difficulty)
	return candidates[randi() % candidates.size()]

func get_clue_for_word(word: WordData) -> String:
	return word.clue

func get_available_letters(word: String) -> PackedStringArray:
	# Return letters for WordInput
	return word.split("")
```

---

##### `WordValidator.gd`
**Fungsi:** Validasi input kata pemain.

```gdscript
func validate(player_input: String, correct_answer: String) -> ValidationResult:
	var normalized_input = player_input.to_upper().strip_edges()
	var normalized_answer = correct_answer.to_upper().strip_edges()
	
	var is_valid = normalized_input == normalized_answer
	
	return ValidationResult.new(
		valid=is_valid,
		input=player_input,
		answer=correct_answer
	)
```

---

##### `WordData.gd`
**Fungsi:** Objek data yang merepresentasikan satu kata.

```gdscript
class_name WordData
extends Resource

@export var word: String
@export var clue: String
@export var difficulty: int
@export var category: String
@export var stage_requirement: int
```

---

##### `ClueManager.gd`
**Fungsi:** Mengelola clue untuk kata.

**Tanggung jawab:**
- Ambil clue dari WordManager
- Pilih clue sesuai kesulitan/stage
- Hindari pengulangan clue dalam battle yang sama

---

#### `scripts/entities/` — Skrip Entitas

##### `Player.gd`
**Fungsi:** Kontrol karakter pemain.

```gdscript
@export var max_hp: int = 20
@export var damage: int = 3

var current_hp: int
var state: String = "idle"  # idle, attacking, hurt, defeated

func _ready():
	current_hp = max_hp
	play_animation("idle")

func take_damage(amount: int):
	current_hp -= amount
	if current_hp <= 0:
		current_hp = 0
		die()
	else:
		play_animation("hurt")

func attack():
	play_animation("attack")
	AudioManager.play_sfx("attack")

func die():
	state = "defeated"
	play_animation("defeat")
	emit_signal("player_defeated")
```

---

##### `Enemy.gd`
**Fungsi:** Kontrol perilaku musuh.

**Catatan penting:** Properti dimuat dari `enemies.json`, bukan hardcoded.

```gdscript
@export var enemy_id: String = "enemy_01"

var hp: int
var damage: int
var word_speed: float
var enemy_data: Dictionary

func _ready():
	enemy_data = load_enemy_data(enemy_id)
	hp = enemy_data["hp"]
	damage = enemy_data["damage"]
	word_speed = enemy_data["wordSpeed"]
	
	load_sprite(enemy_data["sprite"])

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		die()

func generate_word():
	# AI: bentuk kata dengan word_speed multiplier
	var delay = 2.0 / word_speed
	await get_tree().create_timer(delay).timeout
	emit_signal("word_completed")
```

---

##### `PowerUp.gd`
**Fungsi:** Kontrol perilaku power-up.

```gdscript
@export var powerup_id: String = "overclock"

var powerup_data: Dictionary

func _ready():
	powerup_data = load_powerup_data(powerup_id)

func activate():
	AudioManager.play_sfx("powerup")
	play_animation("activate")
	
	match powerup_data["effectType"]:
		"damage_boost":
			apply_damage_boost(powerup_data["effectValue"])
		"block_attack":
			apply_block(powerup_data["effectValue"])
	
	emit_signal("powerup_activated", powerup_id)
```

---

#### `scripts/ui/` — Skrip Antarmuka UI

Setiap scene di `scenes/ui/` memiliki skrip GDScript yang sesuai dengan nama yang sama:

| Scene | Script | Fungsi |
|---|---|---|
| `BattleUI.tscn` | `BattleUI.gd` | Update HP, word count, clue display, animasi |
| `MainMenuUI.tscn` | `MainMenuUI.gd` | **Kontrol tombol menu, navigasi ke scene** |
| `WordInput.tscn` | `WordInput.gd` | Handle keyboard/drag input, emit word_completed signal |
| `LetterTile.tscn` | `LetterTile.gd` | Handle mouse input, drag logic, selection visual |
| `HealthBar.tscn` | `HealthBar.gd` | Update bar animation, show HP values |
| `WordProgress.tscn` | `WordProgress.gd` | Update progress bars, animate leader indicator |
| `PowerUpUI.tscn` | `PowerUpUI.gd` | Display power-ups, handle activation input |
| `DamagePopup.tscn` | `DamagePopup.gd` | Animate popup, fade out, remove self |
| `Countdown.tscn` | `Countdown.gd` | Countdown animation, sound effects |

---

#### `scripts/managers/` — Sistem Cross-Scene

##### `InputManager.gd`
**Fungsi:** Memusatkan semua penanganan input.

**Tanggung jawab:**
- Menangani input keyboard
- Menangani input mouse
- Game-specific input actions
- Manajemen state input

**Catatan:** Input huruf normal diproses lewat event keyboard/text Godot, bukan dengan membuat input action untuk setiap huruf (tidak scalable).

---

##### `AchievementManager.gd`
**Fungsi:** Mengelola achievement game.

**Tanggung jawab:**
- Track kondisi achievement
- Unlock achievement saat terpenuhi
- Simpan progress achievement
- Notifikasi ke Achievement UI

**Timeline:** Dikerjakan setelah sistem battle sudah stabil (Priority 4).

---

### 6. `shaders/` — Custom Godot Shaders

##### `hit_flash.gdshader`
**Fungsi:** Efek kilatan singkat saat terkena serangan.

**Visual:**
```
Enemy menerima damage
	↓
hit_flash shader dijalankan
	↓
Enemy berkilat putih/terang singkat
	↓
Kembali ke sprite normal
```

**Keuntungan:** Memberikan feedback visual yang kuat tanpa perlu sprite tambahan.

---

##### `outline.gdshader`
**Fungsi:** Menambah atau memodifikasi garis tepi sprite.

**Kegunaan:**
- Garis tepi karakter (sesuai gaya doodle)
- Garis tepi musuh
- Highlight letter tile yang dipilih
- Highlight elemen UI yang aktif

---

### 7. `icon.svg`
**Fungsi:** Ikon proyek dan aplikasi Godot.

**Digunakan untuk:**
- Window game icon
- Executable icon
- Godot project identification

**Rekomendasi:** Ganti ikon bawaan Godot dengan logo game yang custom.

---

### 8. `FileStructure.md`
Dokumen ini sendiri — penjelasan lengkap struktur proyek.

---

## 🏗️ Arsitektur Sistem Keseluruhan

```text
┌────────────────────────────────────────────────────────────┐
│                      GameManager                            │
│            (state global: score, stage, progress)          │
└────────────────────┬─────────────────────────────────────┘
					 │
					 ▼
┌────────────────────────────────────────────────────────────┐
│                    MainGame.gd                              │
│          (mengatur alur gameplay keseluruhan)              │
└────────────────────┬─────────────────────────────────────┘
					 │
					 ▼
┌────────────────────────────────────────────────────────────┐
│                  StageManager.gd                            │
│       (load stage, musuh, background dari JSON)            │
└────────────────────┬─────────────────────────────────────┘
					 │
					 ▼
┌────────────────────────────────────────────────────────────┐
│                    Battle.gd                                │
│         (koordinasi pertarungan, logic pertukaran)         │
├────────────────────────────────────────────────────────────┤
│  ├─ BattleManager.gd (kalkulasi damage, effects)           │
│  ├─ CombatManager.gd (state machine combat)                │
│  ├─ Player.gd (HP, animasi, stats pemain)                 │
│  ├─ Enemy.gd (HP, AI, stats musuh dari JSON)              │
│  ├─ WordManager.gd (select kata & clue)                   │
│  │   ├─ WordData.gd (object satu kata)                    │
│  │   └─ ClueManager.gd (manage clue)                      │
│  └─ WordValidator.gd (validasi input)                     │
└──────────────────────┬──────────────────────────────────────┘
					   │
		┌──────────────┼──────────────┐
		▼              ▼              ▼
	Player         Enemy        BattleUI.gd
   (display)     (display)   (update tampilan)
							 ├─ WordInput.gd
							 ├─ LetterTile.gd
							 ├─ HealthBar.gd
							 ├─ WordProgress.gd
							 ├─ PowerUpUI.gd
							 ├─ DamagePopup.gd
							 └─ Countdown.gd
		│              │              │
		└──────────────┼──────────────┘
					   ▼
		┌──────────────────────────────┐
		│    AudioManager (Autoload)   │
		│   (BGM, SFX volume, buses)   │
		└──────────────────────────────┘
```

---

## 🔄 Alur Word-Combat Loop (Flowchart Lengkap)

```text
START BATTLE
	 │
	 ▼
┌─────────────────────────┐
│  Load Stage Data        │
│ (dari stages.json)      │
│                         │
│ - Enemy ID              │
│ - Background            │
│ - Word Difficulty       │
└────────┬────────────────┘
		 │
		 ▼
┌─────────────────────────┐
│  Load Enemy Data        │
│ (dari enemies.json)     │
│                         │
│ - HP                    │
│ - Damage                │
│ - Word Speed            │
└────────┬────────────────┘
		 │
		 ▼
┌─────────────────────────┐
│  Select Word & Clue     │
│ (dari words.json)       │
│                         │
│ - Difficulty match      │
│ - Stage requirement     │
└────────┬────────────────┘
		 │
		 ▼
   ╔═════════════════════╗
   ║  DISPLAY CLUE       ║
   ╚──────────┬──────────┘
			  │
   ┌──────────┴──────────┐
   │                     │
   ▼                     ▼
 PLAYER TURN         ENEMY TURN
 (manual input)      (AI timer)
   │                     │
   │  ┌─────────────────┐ │
   └─►│ Player Input    │◄┘
	  │ (Keyboard/Drag) │
	  └────────┬────────┘
			   │
			   ▼
		┌──────────────┐
		│ Validate     │
		│ WordValidator│
		└─┬────────────┘
		  │
	   ┌──┴──┐
	   │     │
	Wrong  Correct
	   │     │
	   ▼     ▼
	 ✗ ✓  +1 Word Count
	   │     │
	   │     ▼
	   │  ┌────────────────┐
	   │  │ Compare Counts │
	   │  │                │
	   │  │ Player vs Enemy│
	   │  └────────┬───────┘
	   │           │
	   │    ┌──────┴──────┐
	   │    │             │
	   │  Player       Enemy
	   │  Unggul       Unggul
	   │    │             │
	   └────┤             │
			▼             ▼
	  ┌──────────┐   ┌──────────┐
	  │ Player   │   │  Enemy   │
	  │ Attacks  │   │ Attacks  │
	  └────┬─────┘   └────┬─────┘
		   │              │
		   └──────┬───────┘
				  ▼
		 ┌─────────────────┐
		 │ BattleManager   │
		 │ Calculate DMG   │
		 │                 │
		 │ base_dmg        │
		 │ × multiplier    │
		 │ × crit chance   │
		 └────────┬────────┘
				  │
				  ▼
		 ┌─────────────────┐
		 │ Apply Damage    │
		 │ - Update HP     │
		 │ - Play Sound    │
		 │ - Show Popup    │
		 │ - Play Effect   │
		 └────────┬────────┘
				  │
		 ┌────────┴────────┐
		 │                 │
		Alive           Defeated
		 │                 │
		 ▼                 ▼
   ┌─────────────┐  ┌──────────────┐
   │ Next Word   │  │ Battle End   │
   │ Loop        │  │              │
   └────────┬────┘  │ Show Result  │
			│       │ (victory)    │
			│       └──────┬───────┘
			│              │
			└──────┬───────┘
				   ▼
		 ┌──────────────────┐
		 │  Next Round      │
		 │  or              │
		 │  Stage Complete  │
		 └──────────────────┘
```

---

## 📋 Prioritas Pengembangan (Development Order)

Karena deadline kompetisi singkat, kerjakan dalam urutan ini:

### **Priority 1 — Core Gameplay (WAJIB)**
Sistem minimum yang membuat game dapat dimainkan.

- [ ] `WordManager.gd` — Load words.json, select word
- [ ] `WordValidator.gd` — Validasi input pemain
- [ ] `WordInput.gd` + `WordInput.tscn` — Input keyboard/drag
- [ ] `Battle.gd` — Koordinasi pertarungan
- [ ] `Player.gd` + `Player.tscn` — Pemain
- [ ] `Enemy.gd` + `Enemy.tscn` — Musuh
- [ ] `HealthBar.gd` + `HealthBar.tscn` — Display HP

**Hasil:** Game minimal yang bisa dimainkan 1 vs 1 satu pertarungan.

---

### **Priority 2 — Game Progression (PENTING)**
Menjadikan battle prototype menjadi game loop utuh.

- [ ] `StageManager.gd` — Load stage dari stages.json
- [ ] `MainGame.gd` + `MainGame.tscn` — Alur gameplay
- [ ] `StageClear.tscn` — Layar stage selesai
- [ ] `GameOver.tscn` — Layar kalah
- [ ] `BattleManager.gd` / `CombatManager.gd` — Sistem pertarungan detail

**Hasil:** Game loop utuh: menu → pilih stage → battle → stage clear → stage berikutnya.

---

### **Priority 3 — Gameplay Feedback (POLISH)**
Membuat game terasa responsif dan lebih polished.

- [ ] `DamagePopup.gd` + `DamagePopup.tscn` — Popup damage
- [ ] `WordProgress.gd` + `WordProgress.tscn` — Progress race
- [ ] `Countdown.gd` + `Countdown.tscn` — Hitung mundur
- [ ] `AudioManager.gd` — BGM, SFX, volume
- [ ] `hit_flash.gdshader` — Efek kilatan hit
- [ ] `outline.gdshader` — Efek outline sprite

**Hasil:** Game terasa lebih hidup dan responsif dengan visual & audio feedback.

---

### **Priority 4 — Features Tambahan (OPTIONAL)**
Hanya dikerjakan jika Priority 1-3 sudah stabil dan ada waktu tersisa.

- [ ] `PowerUp.gd` + `PowerUp.tscn` — Sistem power-up
- [ ] `PowerUpUI.gd` + `PowerUpUI.tscn` — UI power-up
- [ ] `SaveManager.gd` — Save/load progress
- [ ] `Settings.tscn` — Menu pengaturan
- [ ] `Achievements.tscn` + `AchievementManager.gd` — Achievement system
- [ ] `InputManager.gd` — Input management terpusat

**Hasil:** Game dengan fitur lengkap dan polis tinggi.

---

## 🎯 Prinsip Desain Proyek

### Pemisahan Tanggung Jawab (Separation of Concerns)

Setiap file/script punya **satu tanggung jawab utama** agar mudah di-maintain dan dikerjakan paralel.

```text
Data Layer
	↓
	JSON files
	├─ words.json
	├─ enemies.json
	├─ stages.json
	└─ powerups.json
	↓
Manager Layer
	↓
	WordManager, StageManager, GameManager, AudioManager
	↓
Gameplay Layer
	↓
	Battle, Player, Enemy
	↓
Entity Layer
	↓
	Individual entities (sprites, animations)
	↓
UI Layer
	↓
	BattleUI, WordInput, LetterTile, HealthBar, etc
	↓
Visual/Audio Assets
	↓
	assets/ folder (sprites, sounds, fonts)
```

### Contoh Flow Nyata: Membentuk Kata

```
words.json
	↓ (WordManager loads)
WordManager.gd
	↓ (Battle requests word)
Battle.gd
	↓ (passes to UI)
BattleUI.tscn → menampilkan clue
WordInput.tscn → pemain ketik
	↓ (emit signal)
WordValidator.gd → validasi
	↓ (if correct)
Battle.gd → update word count
BattleUI.gd → update progress bar
DamagePopup.tscn → tampilkan angka damage
AudioManager.gd → play sound effect
	↓
Efek visual (via shader) → efek hit
```

---

## ✅ Checklist Implementasi

Gunakan checklist ini untuk track progress pengembangan:

### Priority 1 ✓
- [ ] WordManager.gd + words.json
- [ ] WordValidator.gd
- [ ] WordData.gd
- [ ] WordInput.gd + WordInput.tscn
- [ ] LetterTile.gd + LetterTile.tscn
- [ ] Battle.gd + Battle.tscn
- [ ] Player.gd + Player.tscn (basic)
- [ ] Enemy.gd + Enemy.tscn (basic)
- [ ] HealthBar.gd + HealthBar.tscn
- [ ] BattleUI.gd + BattleUI.tscn (basic display)

### Priority 2 ✓
- [ ] StageManager.gd + stages.json, enemies.json
- [ ] MainGame.gd + MainGame.tscn
- [ ] GameManager.gd (autoload)
- [ ] BattleManager.gd / CombatManager.gd
- [ ] StageClear.tscn + logika
- [ ] GameOver.tscn + logika
- [ ] MainMenu.tscn + MainMenuUI.gd
- [ ] Splash.tscn

### Priority 3 ✓
- [ ] DamagePopup.gd + DamagePopup.tscn
- [ ] WordProgress.gd + WordProgress.tscn
- [ ] Countdown.gd + Countdown.tscn
- [ ] AudioManager.gd (autoload)
- [ ] load audio files ke assets/audio/
- [ ] hit_flash.gdshader
- [ ] outline.gdshader

### Priority 4 ✓
- [ ] PowerUp.gd + PowerUp.tscn
- [ ] PowerUpUI.gd + PowerUpUI.tscn
- [ ] powerups.json
- [ ] SaveManager.gd (autoload)
- [ ] Settings.tscn
- [ ] Achievements.tscn
- [ ] AchievementManager.gd
- [ ] InputManager.gd
- [ ] ClueManager.gd

---

## 📞 Tips Kolaborasi Tim

Karena ini adalah project tim dengan deadline singkat:

1. **Pisahkan per sistem:** Satu orang handle WordManager, satu handle Battle, satu handle UI.
2. **Gunakan JSON untuk config:** Jangan hardcode value, gunakan JSON agar mudah di-tweak.
3. **Signal untuk komunikasi:** Gunakan Godot signals agar script tidak tightly coupled.
4. **Test early:** Jangan tunggu semua selesai baru test. Test setiap sistem segera setelah buat.
5. **Document saat membuat:** Tulis komentar di kode, terutama untuk fungsi yang kompleks.
6. **Consistent naming:** Gunakan naming convention yang konsisten (snake_case untuk var/func, PascalCase untuk class).

---

## 🎓 Catatan untuk Discrete Math Students

Proyek ini bagus untuk belajar:
- **Graph theory:** Sistem state machine (UI transitions, combat states)
- **Combinatorics:** Word generation dari huruf-huruf
- **Algorithm:** Word validation, matching, optimization
- **Data structures:** Tree (scene hierarchy), Queue (word input), HashMap (game state)

Mantap buat pembelajaran sambil buat game! 🚀

---

**Last Updated:** 1 October 2026
**Struktur:** Sesuai implementasi aktual proyek Godot
**Status:** Ready untuk development
