# Largest file types report

Cross-platform PowerShell script that scans all files in the input directory and its subdirectories, groups them by file extension, and generates a text report with the top 10 largest file types by total size.

## Requirements

- PowerShell 7 or newer
- `pwsh` command available in `PATH`

## Parameters

- `-InputDirectory` - directory to scan recursively
- `-OutputDirectory` - directory where `report.txt` will be created

## Run

Use the same command on Windows and Linux:

```bash
pwsh -File ./test-task-file-report/report_largest_extensions.ps1 -InputDirectory ./input -OutputDirectory ./output
```

Windows example:

```powershell
pwsh -File .\test-task-file-report\report_largest_extensions.ps1 -InputDirectory C:\Data\Input -OutputDirectory C:\Data\Output
```

Linux example:

```bash
pwsh -File ./test-task-file-report/report_largest_extensions.ps1 -InputDirectory /data/input -OutputDirectory /data/output
```

## Output

The script creates `report.txt` in the output directory.

Example:

```text
Top 10 largest file types by total size
InputDirectory: /data/input

Extension           Summary Value in Mb
.mkv                21210
.avi                15787
.zip                12747
.rar                1347
.mp3                1187
.psd                989
.bmp                900
.gz                 812
.jpg                784
no_extension        20
```

## Notes

- Extensions are normalized to lowercase
- Files without an extension are reported as `no_extension`
- Sorting is performed by total size in descending order
- If the output directory does not exist, it is created automatically
