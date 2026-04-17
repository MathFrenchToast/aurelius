#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function getTimestamp() {
  return new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '');
}

try {
  const inputData = fs.readFileSync(0, 'utf-8');
  if (!inputData) {
    console.log(JSON.stringify({}));
    process.exit(0);
  }
  
  const input = JSON.parse(inputData);
  const response = input.prompt_response || "";

  // Extract markers using Regex
  const summaryMatch = response.match(/\[SUMMARY\]:\s*(.*)/i);
  const nextStepMatch = response.match(/\[NEXT_STEP\]:\s*(.*)/i);

  if (!summaryMatch && !nextStepMatch) {
    console.log(JSON.stringify({}));
    process.exit(0);
  }

  const summary = summaryMatch ? summaryMatch[1].trim() : "N/A";
  const nextStep = nextStepMatch ? nextStepMatch[1].trim() : "NONE";
  
  const logLine = `[${getTimestamp()}] SUMMARY: ${summary}\n[${getTimestamp()}] NEXT_STEP: ${nextStep}\n---\n`;
  
  const logDir = path.join(process.cwd(), 'devlog');
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }

  fs.appendFileSync(path.join(logDir, 'workflow.log'), logLine);

  console.log(JSON.stringify({}));
} catch (e) {
  console.log(JSON.stringify({}));
  process.exit(0);
}
