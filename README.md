## Verilog Assignments & Automation

Repository for my Verilog assignment solutions plus a small Python automation helper.
This is a showcase repository for the automation scripts, as well as my Verilog assignments solutions for Computer Organizations course offered by Sukarn Aggrawal, in my final year of Bachelor of Science.

### Scripts

| Script | Purpose |
|--------|---------|
| `verilog_automation.py` | Core automation: compile (`iverilog`), simulate (`vvp`), capture terminal (optional `termshot`), parse VCD, render GTKWave‑style waveform PNGs with annotated values. |
| `create_config.py` | Convenience generator: scans assignment folders and writes a JSON config listing `.v` files. |
| `vcd_info.py` | Raw VCD introspection utility (adapted from `vcdvcd` examples) to inspect structure/signals.
| `test_termshot.py` (optional) | Quick check that `termshot` binary is in PATH. |
| `ExecuteVerliog.ps1` | Simple PowerShell helper: compile provided Verilog sources with `iverilog`, run with `vvp`, optionally open the `.vcd` in GTKWave (`-Plot`). Useful for quick ad‑hoc runs on Windows. |

### Workflow

1. Develop & quick test: On Windows, iterate rapidly using `ExecuteVerilog.ps1` inside the assignment folder. Example: `./ExecuteVerilog.ps1 -Files q1.v` (add `-Plot` if you want to open GTKWave manually and have it installed).
2. Generate artifacts: After finishing (or when you want polished artifacts), run the Python automation with `verilog_automation.py <assignment>.json` under WSL/Linux/macOS. This produces the terminal screenshot (`*_terminal.png`) via `termshot` (requires that binary in PATH) and waveform image (`*_waveform.png`). Windows native PowerShell typically cannot capture terminal images; WSL is recommended.
3. Bundle for submission: Use `BundleHomework.ps1 -Assignment <folder>` to create `<folder>_submission.zip` containing all `.v` (and any `.pdf`) files. This relies on `7z` being installed and available in PATH.

Notes:
- Ensure the JSON config lists each Verilog source you need processed; regenerate with `create_config.py` if files are updated/added.
- If `termshot` is unavailable the automation will skip terminal PNG generation but still create waveform images (assuming VCD dumped).
- Use WSL for a smoother toolchain if you're primarily on Windows (easier to install `termshot`, `gtkwave`, and Python packages).

### Folder Structure

```
<repo_root>/
  Asg1/                # Assignment folder (one per set)
    q1.v
    imgs/              # Generated images (terminal + waveform)
  config/
    Asg1.json         # Generated config (one per assignment)
  verilog_automation.py
  create_config.py
  vcd_info.py
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
* `wsl` (if on Windows, for easier toolchain setup)

### Generate a Config

Automatically (all assignments with `.v` files):
```bash
python create_config.py <assignment_folder>
```
Or hand‑write a minimal one (defaults in [`create_config.py`](./create_config.py)):

```json
{
  "folder": "Asg1",
  "files": [ { "name": "q1.v" } ]
}
```

### Run Automation

```bash
python verilog_automation.py config/Asg1.json
```

Outputs land in `Asg1/imgs/`:
* `*_terminal.png` – terminal run (if `termshot` available)
* `*_waveform.png` – dark waveform with green traces + inline bin values

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
