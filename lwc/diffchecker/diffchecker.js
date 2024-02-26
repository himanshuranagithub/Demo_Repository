// codeDifference.js
import { LightningElement, track } from 'lwc';

export default class diffchecker extends LightningElement {
    @track codeA = '';
    @track codeB = '';
    @track diffLines = [];

    handleChange(event) {
        this[event.target.label.toLowerCase()] = event.target.value;
    }

    handleCompare() {
        const tokensA = this.tokenizeCode(this.codeA);
        const tokensB = this.tokenizeCode(this.codeB);

        this.diffLines = this.computeDiff(tokensA, tokensB);
    }

    tokenizeCode(code) {
        const lines = code.split('\n');
        let tokens = [];

        lines.forEach((line, index) => {
            tokens.push({ key: index, value: line, className: 'unchanged' });
        });

        return tokens;
    }

    computeDiff(tokensA, tokensB) {
        const diffLines = [];
        const diff = this.computeDiffMatrix(tokensA, tokensB);

        let row = 0;
        let col = 0;

        while (row < tokensA.length || col < tokensB.length) {
            const valueA = tokensA[row] ? tokensA[row].value : '';
            const valueB = tokensB[col] ? tokensB[col].value : '';

            if (diff[row + 1] && diff[row + 1][col] === diff[row][col] + 1) {
                diffLines.push({ key: row, value: valueA, className: 'removed' });
                row += 1;
            } else if (diff[row][col + 1] === diff[row][col] + 1) {
                diffLines.push({ key: col, value: valueB, className: 'added' });
                col += 1;
            } else {
                diffLines.push({ key: row, value: valueA, className: 'unchanged' });
                row += 1;
                col += 1;
            }
        }

        return diffLines;
    }

    computeDiffMatrix(tokensA, tokensB) {
        const m = tokensA.length;
        const n = tokensB.length;

        const diff = [];

        for (let i = 0; i <= m; i++) {
            diff[i] = [];
            for (let j = 0; j <= n; j++) {
                if (i === 0) {
                    diff[i][j] = j;
                } else if (j === 0) {
                    diff[i][j] = i;
                } else if (tokensA[i - 1].value === tokensB[j - 1].value) {
                    diff[i][j] = diff[i - 1][j - 1];
                } else {
                    diff[i][j] = 1 + Math.min(diff[i - 1][j], diff[i][j - 1], diff[i - 1][j - 1]);
                }
            }
        }

        return diff;
    }
}