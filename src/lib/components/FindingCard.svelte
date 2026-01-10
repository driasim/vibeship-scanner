<script lang="ts">
	import type { VibeOutput } from '$lib/vibeTransformer';

	interface Props {
		finding: VibeOutput;
		index: number;
		scanId: string;
		onCopyPrompt?: (prompt: string) => void;
	}

	let { finding, index, scanId, onCopyPrompt }: Props = $props();

	let isExpanded = $state(false);
	let showTechnical = $state(false);
	let copied = $state<string | null>(null);

	// False positive reporting state
	let showFpReport = $state(false);
	let fpReason = $state<string>('');
	let fpSubmitting = $state(false);
	let fpResult = $state<'success' | 'error' | null>(null);

	const FP_REASONS = [
		{ value: 'safe_pattern', label: 'Code is actually safe', desc: 'The pattern is safe in this context' },
		{ value: 'framework_handled', label: 'Framework handles it', desc: 'Security framework/library provides protection' },
		{ value: 'test_code', label: 'Test/mock code only', desc: 'This is only in test files, not production' },
		{ value: 'intentional', label: 'Intentional design', desc: 'Developer intentionally wrote it this way' },
		{ value: 'wrong_context', label: 'Rule doesn\'t apply', desc: 'The rule misunderstands this code pattern' },
		{ value: 'other', label: 'Other reason', desc: 'Different reason not listed' }
	];

	async function submitFalsePositive() {
		if (!fpReason) return;

		fpSubmitting = true;
		fpResult = null;

		try {
			const response = await fetch('https://scanner-empty-field-5676.fly.dev/feedback/report', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					rule_id: finding.technicalDetails.ruleId,
					rule_message: finding.headline,
					severity: finding.technicalDetails.severity.toUpperCase(),
					language: getLanguageFromPath(finding.where.file),
					code_snippet: finding.vulnerableCode?.code || finding.headline,
					reason_category: fpReason,
					consent_level: 1 // Anonymous by default
				})
			});

			if (response.ok) {
				fpResult = 'success';
				setTimeout(() => {
					showFpReport = false;
					fpResult = null;
					fpReason = '';
				}, 2000);
			} else {
				fpResult = 'error';
			}
		} catch (e) {
			fpResult = 'error';
		} finally {
			fpSubmitting = false;
		}
	}

	function getLanguageFromPath(path: string): string {
		const ext = path.split('.').pop()?.toLowerCase() || '';
		const langMap: Record<string, string> = {
			'sol': 'solidity', 'js': 'javascript', 'ts': 'typescript',
			'py': 'python', 'go': 'go', 'rs': 'rust', 'rb': 'ruby',
			'java': 'java', 'php': 'php', 'c': 'c', 'cpp': 'cpp'
		};
		return langMap[ext] || 'unknown';
	}

	function toggleExpand() {
		isExpanded = !isExpanded;
	}

	function copyToClipboard(text: string, type: string) {
		navigator.clipboard.writeText(text);
		copied = type;
		setTimeout(() => (copied = null), 2000);
		if (type === 'prompt' && onCopyPrompt) {
			onCopyPrompt(text);
		}
	}

	function getUrgencyColor(urgency: string): string {
		switch (urgency) {
			case 'ship-blocker':
				return '#ef4444';
			case 'fix-this-week':
				return '#f97316';
			case 'good-to-fix':
				return '#eab308';
			case 'consider':
				return '#3b82f6';
			default:
				return 'var(--text-tertiary)';
		}
	}
</script>

<div class="finding-card" class:expanded={isExpanded}>
	<!-- Card Header - Always Visible -->
	<button class="card-header" onclick={toggleExpand}>
		<div class="header-top">
			<span
				class="urgency-badge {finding.urgency}"
			>
				{#if finding.urgency === 'ship-blocker'}Critical
				{:else if finding.urgency === 'fix-this-week'}High
				{:else if finding.urgency === 'good-to-fix'}Medium
				{:else if finding.urgency === 'consider'}Low
				{:else}Info{/if}
			</span>
			<span class="finding-number">#{index + 1}</span>
		</div>

		<h3 class="headline">{finding.headline}</h3>

		<div class="location">
			<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
				<path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z" />
				<polyline points="13 2 13 9 20 9" />
			</svg>
			<code>{finding.where.displayPath}</code>
		</div>

		<span class="chevron" class:rotated={isExpanded}>
			<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
				<polyline points="6 9 12 15 18 9" />
			</svg>
		</span>
	</button>

	<!-- Expanded Content -->
	{#if isExpanded}
		<div class="card-content">
			<!-- What's Wrong -->
			<div class="section">
				<h4 class="section-title">What's wrong</h4>
				<p class="whats-wrong">{finding.whatsWrong}</p>
			</div>

			<!-- What Could Happen -->
			<div class="section">
				<h4 class="section-title">What could happen</h4>
				<ul class="consequences">
					{#each finding.consequences.slice(0, 3) as consequence}
						<li>{consequence}</li>
					{/each}
				</ul>
			</div>

			<!-- Vulnerable Code -->
			{#if finding.vulnerableCode}
				<div class="section">
					<h4 class="section-title">The vulnerable code</h4>
					<pre class="code-block"><code>{finding.vulnerableCode.code}</code></pre>
				</div>
			{/if}

			<!-- AI Fix Prompt - The Star of the Show -->
			<div class="section ai-prompt-section">
				<div class="prompt-header">
					<h4 class="section-title">AI Fix Prompt</h4>
					<span class="prompt-hint">Copy and paste into Claude, Cursor, or ChatGPT</span>
				</div>
				<div class="prompt-box">
					<pre class="prompt-text">{finding.aiFixPrompt}</pre>
					<button
						class="copy-btn"
						class:copied={copied === 'prompt'}
						onclick={() => copyToClipboard(finding.aiFixPrompt, 'prompt')}
					>
						{#if copied === 'prompt'}
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
								<polyline points="20 6 9 17 4 12" />
							</svg>
							Copied!
						{:else}
							<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
								<rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
								<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
							</svg>
							Copy Prompt
						{/if}
					</button>
				</div>
			</div>

			<!-- Technical Details (Collapsed) -->
			<details class="technical-details" bind:open={showTechnical}>
				<summary class="technical-summary">
					<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
						<circle cx="12" cy="12" r="10" />
						<line x1="12" y1="16" x2="12" y2="12" />
						<line x1="12" y1="8" x2="12.01" y2="8" />
					</svg>
					Technical Details
					<span class="toggle-icon">{showTechnical ? '−' : '+'}</span>
				</summary>
				<div class="technical-content">
					<div class="tech-grid">
						{#if finding.technicalDetails.cweId}
							<div class="tech-item">
								<span class="tech-label">CWE</span>
								<span class="tech-value">{finding.technicalDetails.cweId}</span>
							</div>
						{/if}
						{#if finding.technicalDetails.cweName}
							<div class="tech-item">
								<span class="tech-label">Name</span>
								<span class="tech-value">{finding.technicalDetails.cweName}</span>
							</div>
						{/if}
						{#if finding.technicalDetails.cvssScore}
							<div class="tech-item">
								<span class="tech-label">CVSS</span>
								<span class="tech-value cvss" style="color: {getUrgencyColor(finding.urgency)}">
									{finding.technicalDetails.cvssScore} ({finding.technicalDetails.cvssLabel})
								</span>
							</div>
						{/if}
						{#if finding.technicalDetails.owaspCategory}
							<div class="tech-item">
								<span class="tech-label">OWASP</span>
								<span class="tech-value">{finding.technicalDetails.owaspCategory}</span>
							</div>
						{/if}
						<div class="tech-item">
							<span class="tech-label">Rule ID</span>
							<span class="tech-value mono">{finding.technicalDetails.ruleId}</span>
						</div>
						<div class="tech-item">
							<span class="tech-label">Severity</span>
							<span class="tech-value">{finding.technicalDetails.severity.toUpperCase()}</span>
						</div>
					</div>
				</div>
			</details>

			<!-- False Positive Report Section -->
			<div class="fp-report-section">
				{#if !showFpReport}
					<button class="fp-toggle-btn" onclick={() => showFpReport = true}>
						<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
							<path d="M3 3l7.07 16.97 2.51-7.39 7.39-2.51L3 3z" />
							<path d="M13 13l6 6" />
						</svg>
						Report False Positive
					</button>
				{:else}
					<div class="fp-report-form">
						<div class="fp-header">
							<h4>Report False Positive</h4>
							<button class="fp-close" onclick={() => { showFpReport = false; fpReason = ''; }}>×</button>
						</div>

						{#if fpResult === 'success'}
							<div class="fp-success">
								<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
									<polyline points="20 6 9 17 4 12" />
								</svg>
								Thanks! Your feedback helps improve the scanner.
							</div>
						{:else if fpResult === 'error'}
							<div class="fp-error">
								Failed to submit. Please try again.
							</div>
						{:else}
							<p class="fp-description">Why is this a false positive?</p>

							<div class="fp-reasons">
								{#each FP_REASONS as reason}
									<label class="fp-reason-option" class:selected={fpReason === reason.value}>
										<input
											type="radio"
											name="fp-reason"
											value={reason.value}
											bind:group={fpReason}
											class="fp-radio-input"
										/>
										<span class="fp-radio-indicator">
											{#if fpReason === reason.value}
												<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
													<polyline points="20 6 9 17 4 12" />
												</svg>
											{/if}
										</span>
										<div class="fp-reason-content">
											<span class="fp-reason-label">{reason.label}</span>
											<span class="fp-reason-desc">{reason.desc}</span>
										</div>
									</label>
								{/each}
							</div>

							<div class="fp-actions">
								<button
									class="fp-submit-btn"
									onclick={submitFalsePositive}
									disabled={!fpReason || fpSubmitting}
								>
									{#if fpSubmitting}
										Submitting...
									{:else}
										Submit Report
									{/if}
								</button>
							</div>

							<div class="fp-privacy-note">
								<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
									<rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
									<path d="M7 11V7a5 5 0 0 1 10 0v4"/>
								</svg>
								<span>Your privacy is protected. We only collect the rule ID and your selected reason — no code, file paths, or identifying information is ever sent.</span>
							</div>
						{/if}
					</div>
				{/if}
			</div>
		</div>
	{/if}
</div>

<style>
	.finding-card {
		background: var(--bg-primary);
		border: 1px solid var(--border);
		margin-bottom: 1rem;
		transition: all 0.15s ease;
	}

	.finding-card:hover {
		border-color: var(--text-tertiary);
	}

	.finding-card.expanded {
		border-color: var(--text-secondary);
	}

	/* Card Header */
	.card-header {
		width: 100%;
		padding: 1rem;
		background: transparent;
		border: none;
		text-align: left;
		cursor: pointer;
		position: relative;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.header-top {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.urgency-badge {
		font-family: 'JetBrains Mono', monospace;
		font-size: 0.65rem;
		font-weight: 500;
		padding: 0.2rem 0.5rem;
		text-transform: uppercase;
		letter-spacing: 0.02em;
		border: 1px solid var(--border);
		background: var(--bg-secondary);
		color: var(--text-tertiary);
	}

	.urgency-badge.ship-blocker {
		color: #ef4444;
		border-color: rgba(239, 68, 68, 0.3);
	}

	.urgency-badge.fix-this-week {
		color: #f97316;
		border-color: rgba(249, 115, 22, 0.3);
	}

	.urgency-badge.good-to-fix {
		color: #eab308;
		border-color: rgba(234, 179, 8, 0.3);
	}

	.urgency-badge.consider {
		color: #3b82f6;
		border-color: rgba(59, 130, 246, 0.3);
	}

	.urgency-badge.fyi {
		color: var(--text-tertiary);
		border-color: var(--border);
	}

	.finding-number {
		font-size: 0.75rem;
		color: var(--text-tertiary);
		font-family: 'JetBrains Mono', monospace;
	}

	.headline {
		font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		font-size: 1.05rem;
		font-weight: 600;
		color: var(--text-primary);
		margin: 0;
		padding-right: 2rem;
		line-height: 1.5;
		letter-spacing: -0.01em;
	}

	.location {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		color: var(--text-tertiary);
	}

	.location svg {
		flex-shrink: 0;
	}

	.location code {
		font-size: 0.8rem;
		background: var(--bg-secondary);
		padding: 0.15rem 0.4rem;
		color: var(--text-secondary);
		word-break: break-all;
	}

	.chevron {
		position: absolute;
		right: 1rem;
		top: 50%;
		transform: translateY(-50%);
		color: var(--text-tertiary);
		transition: transform 0.2s ease;
	}

	.chevron.rotated {
		transform: translateY(-50%) rotate(180deg);
	}

	/* Card Content */
	.card-content {
		padding: 0 1rem 1rem;
		border-top: 1px solid var(--border);
		animation: slideIn 0.15s ease;
	}

	@keyframes slideIn {
		from {
			opacity: 0;
			transform: translateY(-8px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}

	/* Sections */
	.section {
		margin-top: 1rem;
	}

	.section-title {
		font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		font-size: 0.75rem;
		font-weight: 700;
		text-transform: uppercase;
		letter-spacing: 0.04em;
		color: var(--text-tertiary);
		margin: 0 0 0.5rem 0;
	}

	.whats-wrong {
		font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		font-size: 0.95rem;
		line-height: 1.6;
		color: var(--text-secondary);
		margin: 0;
	}

	/* Consequences */
	.consequences {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.consequences li {
		position: relative;
		padding-left: 1.25rem;
		font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
		font-size: 0.9rem;
		color: var(--text-secondary);
		margin-bottom: 0.4rem;
		line-height: 1.5;
	}

	.consequences li::before {
		content: '→';
		position: absolute;
		left: 0;
		color: var(--red);
	}

	/* Code Block */
	.code-block {
		margin: 0;
		padding: 0.75rem 1rem;
		background: var(--bg-inverse);
		color: var(--text-inverse);
		font-size: 0.8rem;
		line-height: 1.5;
		overflow-x: auto;
		border-left: 3px solid var(--red);
	}

	.code-block code {
		background: transparent;
		padding: 0;
		font-family: 'JetBrains Mono', 'Fira Code', monospace;
	}

	/* AI Prompt Section - The Main Feature */
	.ai-prompt-section {
		background: var(--bg-secondary);
		margin-left: -1rem;
		margin-right: -1rem;
		padding: 1rem;
		border-top: 1px solid var(--border);
		border-bottom: 1px solid var(--border);
	}

	.prompt-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin-bottom: 0.75rem;
	}

	.prompt-header .section-title {
		margin: 0;
		color: var(--green);
	}

	.prompt-hint {
		font-size: 0.75rem;
		color: var(--text-tertiary);
	}

	.prompt-box {
		position: relative;
		background: var(--bg-inverse);
		border: 1px solid var(--border);
	}

	.prompt-text {
		margin: 0;
		padding: 1rem;
		padding-bottom: 3rem;
		color: var(--text-inverse);
		font-size: 0.8rem;
		line-height: 1.6;
		white-space: pre-wrap;
		word-break: break-word;
		max-height: 300px;
		overflow-y: auto;
		font-family: 'JetBrains Mono', 'Fira Code', monospace;
	}

	.copy-btn {
		position: absolute;
		bottom: 0.75rem;
		right: 0.75rem;
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.5rem 1rem;
		background: var(--green);
		color: white;
		border: none;
		font-size: 0.8rem;
		font-weight: 600;
		cursor: pointer;
		transition: all 0.15s ease;
	}

	.copy-btn:hover {
		background: var(--green-dim);
	}

	.copy-btn.copied {
		background: var(--green-dim);
	}

	/* Technical Details */
	.technical-details {
		margin-top: 1rem;
		border: 1px solid var(--border);
	}

	.technical-summary {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.75rem 1rem;
		background: var(--bg-tertiary);
		cursor: pointer;
		font-size: 0.8rem;
		color: var(--text-secondary);
		list-style: none;
	}

	.technical-summary::-webkit-details-marker {
		display: none;
	}

	.toggle-icon {
		margin-left: auto;
		font-family: monospace;
		font-size: 1rem;
	}

	.technical-summary:hover {
		background: var(--bg-secondary);
	}

	.technical-content {
		padding: 1rem;
		background: var(--bg-secondary);
	}

	.tech-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
		gap: 0.75rem;
	}

	.tech-item {
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
	}

	.tech-label {
		font-size: 0.65rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-tertiary);
	}

	.tech-value {
		font-size: 0.85rem;
		color: var(--text-primary);
	}

	.tech-value.mono {
		font-family: 'JetBrains Mono', monospace;
		font-size: 0.75rem;
	}

	.tech-value.cvss {
		font-weight: 600;
	}

	/* False Positive Report Styles */
	.fp-report-section {
		margin-top: 1rem;
		padding-top: 1rem;
		border-top: 1px solid var(--border);
	}

	.fp-toggle-btn {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.5rem 0.875rem;
		font-size: 0.8rem;
		color: var(--text-secondary);
		background: transparent;
		border: 1px solid var(--border);
		cursor: pointer;
		transition: all 0.2s ease;
	}

	.fp-toggle-btn:hover {
		color: var(--text-primary);
		border-color: var(--text-tertiary);
		background: var(--bg-secondary);
	}

	.fp-report-form {
		background: var(--bg-tertiary);
		padding: 1rem;
	}

	.fp-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.75rem;
	}

	.fp-header h4 {
		margin: 0;
		font-size: 0.9rem;
		color: var(--text-primary);
	}

	.fp-close {
		background: transparent;
		border: none;
		color: var(--text-tertiary);
		cursor: pointer;
		padding: 0.25rem;
		font-size: 1.25rem;
		line-height: 1;
	}

	.fp-close:hover {
		color: var(--text-primary);
	}

	.fp-success {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.75rem;
		background: rgba(34, 197, 94, 0.1);
		border: 1px solid rgba(34, 197, 94, 0.3);
		color: #22c55e;
		font-size: 0.85rem;
	}

	.fp-error {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.75rem;
		background: rgba(239, 68, 68, 0.1);
		border: 1px solid rgba(239, 68, 68, 0.3);
		color: #ef4444;
		font-size: 0.85rem;
	}

	.fp-description {
		font-size: 0.8rem;
		color: var(--text-secondary);
		margin-bottom: 0.75rem;
	}

	.fp-reasons {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}

	.fp-reason-option {
		display: flex;
		align-items: flex-start;
		gap: 0.75rem;
		padding: 0.75rem 1rem;
		background: var(--bg-secondary);
		border: 1px solid var(--border);
		cursor: pointer;
		transition: all 0.15s ease;
	}

	.fp-reason-option:hover {
		border-color: var(--text-tertiary);
		background: var(--bg-tertiary);
	}

	.fp-reason-option.selected {
		border-color: var(--accent);
		background: rgba(59, 130, 246, 0.08);
	}

	/* Hide native radio input */
	.fp-radio-input {
		position: absolute;
		opacity: 0;
		pointer-events: none;
	}

	/* Custom radio indicator - square Vibeship style */
	.fp-radio-indicator {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 20px;
		height: 20px;
		min-width: 20px;
		border: 2px solid var(--border);
		background: var(--bg-primary);
		margin-top: 0.125rem;
		transition: all 0.15s ease;
	}

	.fp-reason-option:hover .fp-radio-indicator {
		border-color: var(--text-tertiary);
	}

	.fp-reason-option.selected .fp-radio-indicator {
		border-color: var(--accent);
		background: var(--accent);
		color: white;
	}

	.fp-reason-content {
		flex: 1;
	}

	.fp-reason-label {
		display: block;
		font-size: 0.85rem;
		color: var(--text-primary);
		font-weight: 500;
	}

	.fp-reason-desc {
		display: block;
		font-size: 0.75rem;
		color: var(--text-tertiary);
		margin-top: 0.25rem;
	}

	.fp-actions {
		display: flex;
		justify-content: center;
		margin-bottom: 1rem;
	}

	.fp-submit-btn {
		width: 100%;
		padding: 0.75rem 1.5rem;
		font-size: 0.9rem;
		font-weight: 600;
		color: white;
		background: var(--accent);
		border: none;
		cursor: pointer;
		transition: all 0.2s ease;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}

	.fp-submit-btn:hover:not(:disabled) {
		background: var(--accent-hover);
	}

	.fp-submit-btn:disabled {
		opacity: 0.4;
		cursor: not-allowed;
	}

	.fp-privacy-note {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		padding: 0.75rem;
		background: var(--bg-secondary);
		border: 1px solid var(--border);
		font-size: 0.75rem;
		color: var(--text-tertiary);
		line-height: 1.4;
	}

	.fp-privacy-note svg {
		flex-shrink: 0;
		margin-top: 0.125rem;
		color: var(--text-tertiary);
	}

	/* Mobile Responsive */
	@media (max-width: 600px) {
		.card-header {
			padding: 0.875rem;
		}

		.headline {
			font-size: 0.95rem;
		}

		.location code {
			font-size: 0.75rem;
		}

		.prompt-text {
			font-size: 0.75rem;
			max-height: 250px;
		}

		.tech-grid {
			grid-template-columns: 1fr;
		}
	}
</style>
