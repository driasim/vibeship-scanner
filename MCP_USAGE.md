# Vibeship Scanner MCP Integration

Use Vibeship Scanner directly from Claude, Cursor, or any MCP-compatible AI assistant.

## Quick Setup

Add to your Claude Desktop config (`claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "vibeship-scanner": {
      "command": "npx",
      "args": ["mcp-remote", "https://scanner.vibeship.co/mcp"]
    }
  }
}
```

Or for Claude Code (`.claude/settings.json`):

```json
{
  "mcpServers": {
    "vibeship-scanner": {
      "command": "npx",
      "args": ["mcp-remote", "https://scanner.vibeship.co/mcp"]
    }
  }
}
```

Restart Claude after adding the config.

---

## Available Tools

| Tool | Description |
|------|-------------|
| `scanner_scan` | Start a security scan on any GitHub repo |
| `scanner_status` | Check scan progress with visual progress bar |
| `scanner_master_prompt` | Get AI fix guide with TodoWrite task list |
| `scanner_preview_false_positive` | Preview what data would be sent for FP report |
| `scanner_report_false_positive` | Report a false positive (ultra-privacy) |
| `scanner_lookup_cve` | Look up CVE details |
| `scanner_lookup_cwe` | Look up CWE weakness info |

---

## Use Cases

### 1. Scan a Repository

Just ask Claude to scan any public GitHub repo:

```
"Scan https://github.com/owner/repo for security issues"
```

Claude will:
1. Call `scanner_scan` to start the scan
2. Automatically poll `scanner_status` until complete
3. Show you the results with the Vibeship sailboat:

```
               ~
             ╱│
           ╱╲ │
         ╱   ╲│╲         VIBESHIP SCANNER
       ╱  ╱╲  │ ╲        ════════════════
     ╱  ╱   ╲ │  ╲       🎯 SCAN COMPLETE
       ╱     ╲│
   ═══╱═══════╧════
     ∿∿ ∿∿ ∿∿ ∿∿ ∿∿

📦 Repository: https://github.com/owner/repo
📊 Score: 72/100 (Grade C)

   🔴 Critical:   3
   🟠 High:      12
   🟡 Medium:    28
   ⚪ Low:        5
```

---

### 2. Fix All Issues Systematically

After a scan, say:

```
"Fix these security issues"
```

Claude will:
1. Call `scanner_master_prompt` to get the fix guide
2. Create a TodoWrite task list with all issues
3. Work through each fix one by one, marking them complete

**Why this matters**: Without the task list, AI assistants typically fix 1-2 issues then lose track. The TodoWrite integration ensures ALL issues get fixed.

Example task list generated:
```json
[
  {"content": "Fix #1: [CRITICAL] SQL Injection in api/users.js:45", "status": "pending"},
  {"content": "Fix #2: [HIGH] XSS in components/Comment.vue:23", "status": "pending"},
  {"content": "Fix #3: [HIGH] Hardcoded secret in config.py:12", "status": "pending"}
]
```

---

### 3. Report False Positives (Ultra-Privacy)

If the scanner flags something that isn't actually a vulnerability:

```
"This finding #5 is a false positive - it's test code"
```

Claude will:
1. Call `scanner_preview_false_positive` to show what would be sent
2. Ask for confirmation
3. Call `scanner_report_false_positive` to submit

**Privacy guarantee**: We collect ONLY:
- Rule ID (e.g., `js-sql-injection`)
- Language (e.g., `javascript`)
- Reason category (e.g., `test_code`)

We NEVER collect:
- Your code
- File paths
- Repository URLs
- Line numbers
- Any identifying information

This helps us improve detection accuracy while respecting your privacy.

---

### 4. Check Scan Progress

For long-running scans:

```
"What's the status of my scan?"
```

Shows a live progress bar:
```
⏳ SCAN IN PROGRESS...

   [██████████████░░░░░░] 70%

   Current step: sast
   osv-scanner: 12 findings (11/16 scanners)

   ⏱️  This typically takes 1-3 minutes depending on repo size.
```

---

### 5. Look Up Vulnerabilities

Research specific CVEs or CWEs:

```
"What is CVE-2021-44228?"
"Explain CWE-89"
```

Claude will fetch details from NVD/MITRE databases.

---

## Full Workflow Example

Here's a complete session:

**You**: Scan my repo https://github.com/myorg/myapp

**Claude**: Starting security scan...
*[Calls scanner_scan, polls scanner_status]*

```
🎯 SCAN COMPLETE

📊 Score: 45/100 (Grade F)
🛑 Status: DANGER

   🔴 Critical:   5
   🟠 High:      18

🛠️ READY TO FIX?
I can help you fix these issues automatically. Just say:
   "Yes, fix these issues"
```

**You**: Yes, fix these issues

**Claude**: *[Calls scanner_master_prompt, creates TodoWrite tasks]*

I'll work through all 23 issues systematically. Starting with the critical ones...

**Fix #1**: SQL injection in `src/db/queries.js:45`
*[Makes the fix, marks task complete]*

**Fix #2**: Hardcoded API key in `src/config.ts:12`
*[Makes the fix, marks task complete]*

...continues until all done...

**You**: Finding #7 is actually a false positive - it's in our test fixtures

**Claude**: *[Calls scanner_preview_false_positive]*

Here's what would be sent:
```
🔒 ULTRA PRIVACY MODE

What we'll receive:
  • Rule ID: js-eval-injection
  • Language: javascript
  • Reason: test_code

What we will NOT receive:
  • ❌ No code snippets
  • ❌ No file paths
  • ❌ No repository URL
```

Should I submit this report?

**You**: Yes

**Claude**: *[Calls scanner_report_false_positive]*

✅ Thank you! Your false positive report has been submitted. This helps us improve detection accuracy.

---

## Supported Scanners

The MCP endpoint runs 16 security scanners:

| Scanner | What it finds |
|---------|--------------|
| Opengrep | SAST patterns (2,200+ rules) |
| Trivy | Dependency vulnerabilities |
| Gitleaks | Hardcoded secrets |
| OSV-Scanner | Google's OSV database |
| Retire.js | npm package vulnerabilities |
| Hadolint | Dockerfile issues |
| Checkov | IaC security (Terraform, K8s) |
| Brakeman | Ruby/Rails vulnerabilities |
| Slither | Solidity smart contracts |
| Aderyn | Solidity security patterns |
| Mythril | Solidity symbolic execution |
| Solhint | Solidity linting |

---

## Tips

1. **Scan before deploying**: Add to your workflow to catch issues early
2. **Use the task list**: Always say "fix these" to get systematic tracking
3. **Report false positives**: Helps improve the scanner for everyone
4. **Check specific CVEs**: Quick research on vulnerabilities you encounter

---

## Links

- **Web UI**: [scanner.vibeship.co](https://scanner.vibeship.co)
- **MCP Endpoint**: `https://scanner.vibeship.co/mcp`
- **GitHub**: [github.com/vibeforge1111/vibeship-scanner](https://github.com/vibeforge1111/vibeship-scanner)
