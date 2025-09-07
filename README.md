## Verilog Assignments & Automation

Repository for my Verilog assignment solutions plus a small Python automation helper.

### Scripts

| Script | Purpose |
|--------|---------|
| `verilog_automation.py` | Core automation: compile (`iverilog`), simulate (`vvp`), capture terminal (optional `termshot`), parse VCD, render GTKWave‑style waveform PNGs with annotated values. |
| `create_config.py` | Convenience generator: scans assignment folders and writes a JSON config listing `.v` files. |
| `vcd_info.py` | Raw VCD introspection utility (adapted from `vcdvcd` examples) to inspect structure/signals.
| `test_termshot.py` (optional) | Quick check that `termshot` binary is in PATH. |
| `ExecuteVerliog.ps1` | Simple PowerShell helper: compile provided Verilog sources with `iverilog`, run with `vvp`, optionally open the `.vcd` in GTKWave (`-Plot`). Useful for quick ad‑hoc runs on Windows. |

### Folder Structure

```
<repo_root>/
  asg1/                # Assignment folder (one per set)
    q1.v
    q1.vcd
    imgs/              # Generated images (terminal + waveform)
  verilog_automation.py
  create_config.py
  vcd_info.py
  asg1.json            # Example config (one per assignment)
  requirements.txt
  README.md
```

### Requirements

Runtime:
* Python 3.8+ (virtual env recommended)
* Packages: `matplotlib`, `vcdvcd` (install via `pip install -r requirements.txt`)
* Icarus Verilog (`iverilog`, `vvp`) in PATH

Optional:
* `termshot` (terminal screenshots) – https://github.com/homeport/termshot
* `gtkwave` (manual waveform viewing, not required for PNG export)

### Setup

```bash
python -m venv .venv
source .venv/bin/activate    # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Generate a Config

Automatically (all assignments with `.v` files):
```bash
python create_config.py
```

Or hand‑write a minimal one:
```json
{
  "folder": "asg1",
  "files": [ { "name": "q1.v" } ]
}
```

### Run Automation

```bash
python verilog_automation.py asg1.json
```

Outputs land in `asg1/imgs/`:
* `*_terminal.png` – terminal run (if `termshot` available)
* `*_waveform.png` – dark waveform with green traces + inline hex/bin values

### Quick PowerShell Helper (optional)
If you just want a fast manual compile/run (and optionally open GTKWave) without the Python pipeline, use the legacy script:

```powershell
# Compile & simulate q1.v (produces q1.vvp and runs it)
./ExecuteVerliog.ps1 -Files q1.v

# Compile multiple files then open GTKWave on resulting q1.vcd
./ExecuteVerliog.ps1 -Files q1.v q1_tb.v -Plot
```

The Python automation is more feature‑rich (screenshots, annotated PNG waveforms); the PowerShell script remains for quick interactive edits.

### JSON File Fields
| Field | Meaning | Default |
|-------|---------|---------|
| folder | Assignment directory | — (required) |
| files[] | Array of file objects | — |
| files[].name | Verilog source | required |
| files[].vcd_file | VCD filename | `<basename>.vcd` |
| files[].variables | Limit signals plotted | all |
| files[].module | Module prefix to match | `TEST` |
| files[].plot | Enable waveform plotting | `true` |

### Notes
* Waveform renderer applies a compact GTKWave‑like style.
* Multi‑bit values auto‑shown in hex when width multiple of 4, otherwise binary.
* Timing axis shown only on last subplot.
* Annotations are centred to avoid changing layout.

### Troubleshooting (quick)
* `iverilog: command not found` → install Icarus Verilog / fix PATH
* Missing waveforms → check `$dumpfile` / `$dumpvars` in testbench
* No terminal PNG → install `termshot` or skip
* Empty plot → verify `module` matches hierarchical prefix in VCD
