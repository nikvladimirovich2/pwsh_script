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

# What the script does

The script analyzes all files inside a given input directory, groups them by file extension, calculates the total size for each extension, sorts them by total size, and writes a report with the top 10 largest file types.

---

## Step-by-step explanation

### 1. Accepts two required parameters
The script requires:

- `InputDirectory` — the folder to scan
- `OutputDirectory` — the folder where the report will be saved

This means the script does not use hardcoded paths. The user explicitly tells it where to read data from and where to save the result.

---

### 2. Enables strict and safe execution
It sets:

- `Set-StrictMode -Version Latest`
- `$ErrorActionPreference = 'Stop'`

This makes the script more reliable because:

- undeclared variables and unsafe constructs are not silently ignored
- unexpected errors stop execution immediately

This is a good practice for production-style PowerShell scripts.

---

### 3. Defines a helper function to normalize file extensions
The function `Get-ExtensionName` receives a file object and returns:

- the file extension in lowercase, for example `.txt`, `.jpg`, `.zip`
- `no_extension` if the file has no extension

Why this matters:

- `.TXT` and `.txt` are treated as the same file type
- files without extensions are still included in the report instead of being skipped

---

### 4. Validates the input directory
The script checks whether `InputDirectory` exists and is actually a directory.

If it does not exist, the script throws an error and stops.

This prevents meaningless execution and makes failures easy to understand.

---

### 5. Creates the output directory if needed
The script checks whether `OutputDirectory` exists.

If it does not exist, it creates it automatically.

This is useful because the user does not need to manually prepare the destination folder before running the script.

---

### 6. Resolves both paths to full absolute paths
It converts both input and output paths into resolved absolute paths using `Resolve-Path`.

This helps ensure:

- the report contains the real full input path
- file operations are performed consistently even if relative paths were passed in

---

### 7. Builds the final report file path
The script creates the full path to the output file:

- `report.txt`

This file is placed inside the output directory.

---

### 8. Recursively collects all files from the input directory
It uses `Get-ChildItem` with:

- `-File`
- `-Recurse`
- `-Force`

This means:

- it processes files only, not directories
- it scans all subfolders recursively
- it also includes hidden files when possible

So the scan covers the full directory tree, not just the top-level folder.

---

### 9. Prepares the report header
Before processing file statistics, the script creates a list of lines for the report and adds:

- the report title
- the resolved input directory path
- an empty line for readability

This makes the output easier to read and more professional.

---

### 10. Handles the edge case where no files are found
If the input directory contains no files, the script still creates a valid report.

In that case it writes:

- the table header
- a fallback line with `no_extension` and `0`

Then it saves the report and exits successfully.

Why this is useful:

- the script still produces output instead of failing
- automation using this script can rely on the report file always being generated

---

### 11. Groups files by extension
If files are found, the script groups them using the normalized extension returned by `Get-ExtensionName`.

Examples:

- all `.txt` files go into one group
- all `.jpg` files go into another group
- files without extension go into `no_extension`

This is the core aggregation step.

---

### 12. Calculates total size for each extension
For each group, the script sums the `Length` of all files.

This gives the total number of bytes occupied by each file type.

Then it creates a custom object with:

- `Extension`
- `TotalBytes`
- `TotalSizeMb`

`TotalSizeMb` is calculated by converting bytes to megabytes and rounding to 2 decimal places.

---

### 13. Sorts extensions by total size
The script sorts all extension groups by total number of bytes in descending order.

That means the largest file types appear first.

Important detail:
it sorts by raw bytes, not by the rounded MB display value. That is more accurate.

---

### 14. Selects only the top 10
After sorting, it keeps only the first 10 entries.

So the report is limited to the 10 file extensions that consume the most total disk space.

This makes the output concise and focused.

---

### 15. Builds the result table
The script adds a table header:

- `Extension`
- `Summary Value in Mb`

Then it appends one line per extension from the top 10 list.

Each line contains:

- the extension name
- the total size in MB

---

### 16. Writes the report to disk
Finally, it saves all collected lines into:

- `report.txt`

using UTF-8 encoding.

This creates a plain text file that can be easily opened on Windows, Linux, or in any editor.

---

### 17. Prints a success message
At the end, the script outputs:

- `Report created: <path>`

This gives the user immediate confirmation that execution completed successfully and shows where the report was saved.

---

## In one sentence

You can describe the script like this:

> This PowerShell script recursively scans a directory, groups files by extension, calculates the total size of each file type, selects the top 10 largest ones, and writes the results into a text report.

---

## Important implementation details you can mention in an interview

If they ask deeper questions, these points will sound strong and professional:

### Why normalize extensions to lowercase?
To avoid treating `.TXT` and `.txt` as different file types.

### Why handle files without extensions?
Because such files still consume disk space and should be included in the analysis.

### Why sort by bytes instead of MB?
Because bytes are the exact underlying value; MB is only a rounded display format.

### Why create the output directory automatically?
To improve usability and make the script easier to run in automation scenarios.

### Why use strict mode and stop-on-error?
To make failures explicit and prevent silent bugs.

### Why recurse through subdirectories?
Because the goal is to analyze the full contents of the input folder, not only its top level.

---

## One thing you should know about the current README
The README examples currently refer to:

- `./test-task-file-report/report_largest_extensions.ps1`

But in the repository the script is actually located as:

- `report_largest_extensions.ps1`

So if someone asks, you can say:

> The script itself is correct, but the README path should probably be adjusted to match the current repository structure.

---

## Short interview-ready explanation

If you want a short version to say aloud:

> The script takes an input folder and an output folder, scans all files recursively, groups them by extension, sums the total size for each extension, sorts the results from largest to smallest, and writes the top 10 file types into `report.txt`. It also handles files without extensions, creates the output directory automatically, and uses strict error handling for reliability.

If you want, I can also prepare:
1. a **very short spoken version** for interview answers,
2. a **Q&A list of possible interviewer questions with answers in English**,
3. or a **line-by-line code walkthrough in simple English**.

If the user runs the script with an `InputDirectory` they do not have permission to access, the behavior will depend on **which level of access is missing**.

## Case 1: No access to the input directory itself
The script first runs:

```powershell
Test-Path -LiteralPath $InputDirectory -PathType Container
```

If the directory cannot be accessed because of permissions, this check may fail and the script will throw:

> `InputDirectory does not exist or is not a directory: ...`

So from the user’s perspective, the script stops immediately before scanning.

---

## Case 2: Access to the directory exists, but some nested files/folders are restricted
Later the script uses:

```powershell
Get-ChildItem -LiteralPath $resolvedInputDirectory -File -Recurse -Force -ErrorAction SilentlyContinue
```

Here `-ErrorAction SilentlyContinue` is important.

That means:

- permission errors during recursive enumeration are suppressed
- inaccessible files or subfolders are skipped
- the script continues processing the files it *can* access

So in this case the script usually still creates a report, but the report may be **incomplete**, because some files were not included in the scan.

---

## Practical summary

You can explain it like this:

> If the user has no access to the root input directory, the script will fail early.  
> If the root directory is accessible but some subfolders or files are restricted, the script will skip those items silently and generate a report only for the accessible files.

---

## Important consequence
Because access errors inside recursion are silenced, the current script does **not explicitly tell the user** that part of the directory tree was skipped.

So the main risk is:

> the report may look valid, but it may not include all files if some locations were inaccessible.

---

## Interview-style answer
A good short answer in English:

> If the user has no permission to access the input directory at all, the script will stop before processing. If only some nested files or folders are restricted, the script will silently skip them because `Get-ChildItem` uses `-ErrorAction SilentlyContinue`, and the final report may be partial rather than complete.

If you want, I can also explain:
- what happens if the user has no rights to `OutputDirectory`,
- how to improve the script so permission issues are reported more clearly,
- or how to answer this as a stronger “best practice” interview response.
