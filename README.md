# Aether — Multi-Agent Behavior Simulation

A 3D multi-agent simulation framework built with **Godot 4**. Multiple agent types (Hunters, Gatherers, Wanderers) coexist in a shared environment driven by a finite state machine architecture with perception, environmental day/night cycles, and real-time data logging.

Built for **Project Touchstone** — demonstrating systems-level thinking, AI behavior modeling, and extensible simulation architecture.

---

## Architecture

```
aether/
├── config/                        # Configurable parameters (no hardcoded values)
│   ├── agents_config.gd           # Agent counts, speeds, perception radius
│   └── world_config.gd            # World size, resources, day/ncycle settings
├── scenes/
│   ├── main.tscn                  # Root scene
│   └── ui/
│       ├── hud.tscn               # Real-time HUD overlay
│       ├── debug_overlay.tscn     # Debug/stats panel
│       └── agent_inspector.tscn   # Click-to-inspect agent state
├── scripts/
│   ├── bootstrap.gd               # Autoload — input map initialization
│   ├── game_manager.gd            # Autoload — global simulation state
│   ├── world/
│   │   ├── world_generator.gd     # Procedural terrain, resources, obstacles
│   │   ├── resource_node.gd       # Collectible resource (glowing, respawning)
│   │   └── obstacle.gd            # Static obstacles for path blocking
│   ├── agents/
│   │   ├── base_agent.gd          # Base class: health, perception, FSM
│   │   ├── state_machine.gd       # Generic FSM with named state transitions
│   │   ├── state.gd               # Abstract state base class
│   │   ├── states/
│   │   │   ├── idle_state.gd      # Wait then patrol
│   │   │   ├── patrol_state.gd    # Random waypoint wandering
│   │   │   ├── chase_state.gd     # Pursue detected target
│   │   │   ├── flee_state.gd      # Escape from threats
│   │   │   ├── search_state.gd    # Systematic area search
│   │   │   └── interact_state.gd  # Collect resource / attack agent
│   │   ├── hunter_agent.gd        # Aggressive — chases & attacks
│   │   ├── gatherer_agent.gd      # Passive — collects resources
│   │   └── wanderer_agent.gd      # Exploratory — wanders & flees
│   ├── systems/
│   │   ├── perception.gd          # Sight radius + line-of-sight checks
│   │   ├── data_logger.gd         # CSV event logging (session-based)
│   │   ├── spawner.gd             # Agent spawning from config
│   │   └── environment.gd         # Day/night cycle with color lerping
│   └── ui/
│       ├── hud.gd                 # Agent/resource counts, time, speed
│       ├── agent_inspector.gd     # Click-to-inspect agent details
│       └── controls_panel.gd      # Keyboard controls + stats summary
```

---

## Agent Types

| Agent | Role | Behavior |
|-------|------|----------|
| **Hunter** | Predator | Patrols → detects target → chases → attacks (25 dmg). Hunts other agents. |
| **Gatherer** | Collector | Patrols → finds resources → collects → returns to patrol. Scores resources. |
| **Wanderer** | Explorer | Roams randomly → flees from Hunters → continues exploring. Evasive. |

---

## State Machine System

```
                    ┌──────────┐
                    │   Idle   │
                    └────┬─────┘
                         │ timer
                    ┌────▼─────┐
              ┌─────│  Patrol  │◄────┐
              │     └────┬─────┘     │
         detected    ┌───┘│          │
              │      │    │ found   │
        ┌─────▼──┐  │    │ nothing  │
        │ Chase  │  │    │          │
        └────┬───┘  │ ┌──▼─────┐    │
             │      │ │ Search │    │
        ┌────▼───┐  │ └────────┘    │
        │Interact│  │               │
        └────┬───┘  │               │
             └──────┘───────────────┘

  Hunter additional:     Wanderer additional:
  ┌──────┐               ┌──────┐
  │ Flee │ (if hurt)     │ Flee │ (if hunter nearby)
  └──────┘               └──────┘
```

---

## Features

| Feature | Details |
|---------|---------|
| **Finite State Machine** | Generic FSM with named transitions, each state has enter/exit/update/physics_update |
| **Perception System** | Distance-based detection with raycast line-of-sight checks |
| **Procedural Generation** | Terrain, resources, and obstacles placed at random within world bounds |
| **Day/Night Cycle** | Sun rotation + ambient color lerp through 4 phases (night→sunrise→day→sunset) |
| **Data Logging** | All events recorded with timestamps, flushes to `user://agent_log.csv` |
| **Agent Respawn** | Dead agents automatically respawn after configurable delay |
| **Runtime Controls** | Pause, speed up/slow down, toggle debug overlay (F1), agent inspector (F2) |
| **Config-Driven** | No hardcoded values — all parameters in `config/` resource files |

---

## Controls

| Key | Action |
|-----|--------|
| WASD | Move camera |
| Mouse | Look around |
| Left Click | Select agent (inspector mode) |
| F1 | Toggle debug/stats panel |
| F2 | Toggle agent inspector |
| Space | Pause / Resume simulation |
| ] | Speed up (3x) |
| [ | Slow down (0.25x) |
| ESC | Release mouse |

---

## How to Run

1. Download [Godot 4.x](https://godotengine.org/download)
2. Open Godot → **Import** → select `project.godot`
3. Press **F5** (or click Play)

---

## Skills Demonstrated

- **Godot 4** — full project structure, scenes, scripts, autoloads
- **3D simulation** — physics bodies, collisions, raycasting
- **State machine architecture** — reusable FSM with composable states
- **AI behavior modeling** — multi-agent coordination, threat response, resource gathering
- **Procedural content generation** — terrain, objects, and agent placement
- **Data logging & analysis** — event-driven logging with session tracking
- **System design** — separation of concerns (world gen, spawning, environment, perception, UI)
- **Config-driven design** — resource-based configuration files
- **UI programming** — runtime HUD, inspector, and debug overlay
- **Object-oriented design** — class hierarchy (BaseAgent → Hunter/Gatherer/Wanderer, State → 6 concrete states)

---

## Screenshots

*(Add screenshots or a GIF of the simulation running here)*
