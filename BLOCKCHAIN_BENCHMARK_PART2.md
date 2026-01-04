# Blockchain/DeFi Security Benchmark - Part 2

Building on Part 1 (25 repos), this benchmark focuses on additional CTF challenges, exploit repos, and audit datasets not covered previously.

## Scanning Progress Tracker

| # | Repository | Type | Status | Scan ID | Findings | Coverage |
|---|------------|------|--------|---------|----------|----------|
| 1 | [paradigmxyz/paradigm-ctf-2022](https://github.com/paradigmxyz/paradigm-ctf-2022) | Paradigm CTF | Pending | - | - | - |
| 2 | [secureum/secureum-a-maze-x-challenges](https://github.com/secureum/secureum-a-maze-x-challenges) | Secureum CTF | Pending | - | - | - |
| 3 | [secureum/DeFi-Security-Summit-Stanford](https://github.com/secureum/DeFi-Security-Summit-Stanford) | Stanford CTF | Pending | - | - | - |
| 4 | [0xToshii/mr-steal-yo-crypto-ctf-foundry](https://github.com/0xToshii/mr-steal-yo-crypto-ctf-foundry) | DeFi Exploits | Pending | - | - | - |
| 5 | [Quillhash/Quill-CTFs](https://github.com/Quillhash/Quill-CTFs) | Quill CTF | Pending | - | - | - |
| 6 | [fvictorio/evm-puzzles](https://github.com/fvictorio/evm-puzzles) | EVM Bytecode | Pending | - | - | - |
| 7 | [daltyboy11/more-evm-puzzles](https://github.com/daltyboy11/more-evm-puzzles) | EVM Bytecode | Pending | - | - | - |
| 8 | [blockthreat/blocksec-ctfs](https://github.com/blockthreat/blocksec-ctfs) | CTF List | Pending | - | - | - |
| 9 | [sayan011/Immunefi-bug-bounty-writeups-list](https://github.com/sayan011/Immunefi-bug-bounty-writeups-list) | Bug Bounty | Pending | - | - | - |
| 10 | [tpiliposian/Immunefi-bugfixes](https://github.com/tpiliposian/Immunefi-bugfixes) | Critical Bugs | Pending | - | - | - |
| 11 | [federicovilla55/Smart-Contract-Exploitation](https://github.com/federicovilla55/Smart-Contract-Exploitation) | Exploitation | Pending | - | - | - |
| 12 | [0xKitsune/EVM-Book](https://github.com/0xKitsune/EVM-Book) | EVM Reference | Pending | - | - | - |
| 13 | [spearbit/portfolio](https://github.com/spearbit/portfolio) | Bridge Security | Pending | - | - | - |
| 14 | [TradMod/awesome-audits-checklists](https://github.com/TradMod/awesome-audits-checklists) | Audit Checklists | Pending | - | - | - |
| 15 | [shanzson/Smart-Contract-Auditor-Tools-and-Techniques](https://github.com/shanzson/Smart-Contract-Auditor-Tools-and-Techniques) | Auditor Tools | Pending | - | - | - |
| 16 | [code-423n4/2024-07-basin](https://github.com/code-423n4/2024-07-basin) | C4 Audit 2024 | Pending | - | - | - |
| 17 | [sherlock-audit/2024-06-makerdao-endgame](https://github.com/sherlock-audit/2024-06-makerdao-endgame) | Sherlock 2024 | Pending | - | - | - |
| 18 | [x676f64/secureum-mind_map](https://github.com/x676f64/secureum-mind_map) | Secureum Docs | Pending | - | - | - |
| 19 | [0xJuancito/capture-the-ether-solutions](https://github.com/0xJuancito/capture-the-ether-solutions) | CTE Solutions | Pending | - | - | - |
| 20 | [PumpkingWok/CTFGym](https://github.com/PumpkingWok/CTFGym) | CTF Collection | Pending | - | - | - |

---

## Category Breakdown

### CTF Challenges (7 repos)
| Repo | Focus | Expected Vulns |
|------|-------|----------------|
| paradigm-ctf-2022 | Advanced DeFi exploits | Flash loans, MEV, reentrancy |
| secureum-a-maze-x | Multi-level challenges | Access control, oracle manipulation |
| DeFi-Security-Summit-Stanford | Stanford CTF | DeFi-specific vulns |
| mr-steal-yo-crypto | Real exploit simulations | Lending, AMM, governance |
| Quill-CTFs | Beginner-friendly | Common Solidity bugs |
| evm-puzzles | EVM bytecode | Opcodes, gas, memory |
| more-evm-puzzles | Advanced EVM | CREATE, CALL, assembly |

### Bug Bounty & Exploits (4 repos)
| Repo | Focus | Source |
|------|-------|--------|
| Immunefi-bug-bounty-writeups-list | Real bug bounties | Immunefi |
| Immunefi-bugfixes | Critical fixes 2023-24 | Immunefi |
| Smart-Contract-Exploitation | CTF exploits | Various CTFs |
| capture-the-ether-solutions | CTE challenge solutions | Capture The Ether |

### Audit Repos (4 repos)
| Repo | Type | Year |
|------|------|------|
| code-423n4/2024-07-basin | Code4rena | 2024 |
| sherlock-audit/2024-06-makerdao | Sherlock | 2024 |
| spearbit/portfolio | Bridge audits | 2023-24 |
| awesome-audits-checklists | Curated list | Ongoing |

### Reference & Documentation (5 repos)
| Repo | Content |
|------|---------|
| blocksec-ctfs | CTF list & writeups |
| EVM-Book | EVM deep dive |
| secureum-mind_map | Audit techniques |
| Smart-Contract-Auditor-Tools | Tool collection |
| CTFGym | CTF aggregator |

---

## Priority Order

### High Priority (scan first)
1. **paradigm-ctf-2022** - Advanced challenges from Paradigm
2. **secureum-a-maze-x-challenges** - Multi-level Secureum CTF
3. **mr-steal-yo-crypto-ctf-foundry** - Real exploit simulations
4. **Quill-CTFs** - Comprehensive vulnerability coverage

### Medium Priority
5. **DeFi-Security-Summit-Stanford** - Stanford CTF challenges
6. **code-423n4/2024-07-basin** - Recent C4 audit
7. **sherlock-audit/2024-06-makerdao** - Recent Sherlock audit
8. **Smart-Contract-Exploitation** - CTF exploitation examples

### Lower Priority (mostly docs)
9. **evm-puzzles** - Bytecode-only (no Solidity)
10. **Immunefi writeups** - Mostly markdown
11. **Reference repos** - Documentation focused

---

## New Vulnerability Categories (Part 2 Focus)

### Advanced DeFi
- [ ] MEV extraction patterns
- [ ] Cross-protocol reentrancy
- [ ] Governance token manipulation
- [ ] Yield farming exploits
- [ ] Liquidation attacks

### L2 & Bridge Specific
- [ ] Cross-chain message replay
- [ ] Bridge validator bypass
- [ ] Sequencer manipulation
- [ ] Rollup data availability
- [ ] Optimistic fraud proofs

### EVM Deep Dive
- [ ] Gas optimization bugs
- [ ] Memory corruption
- [ ] Storage pointer exploits
- [ ] Create2 address prediction
- [ ] Inline assembly vulnerabilities

---

## Methodology

Same as Part 1:
1. **SCAN**: Trigger scan via API, record scan_id
2. **DOCUMENT**: List all vulnerabilities documented in the repo
3. **GAP ANALYSIS**: Compare findings vs documented vulns
4. **WRITE RULES**: Create Opengrep rules for any gaps
5. **DEPLOY**: `fly deploy --remote-only`
6. **VERIFY**: Rescan and confirm detection with file:line evidence
7. **UPDATE**: Record in this tracking document

---

## Notes

- Many repos in Part 2 are documentation/writeup focused (may have few .sol files)
- EVM puzzles are bytecode-only - test EVM-level rule detection
- Immunefi repos contain real-world exploit patterns
- Bridge security repos important for L2/cross-chain coverage

---

*Created: 2026-01-05*
*Part 1 Repos: 25 | Part 2 Repos: 20 | Total: 45*
