import { LightningElement,track } from 'lwc';

export default class DifferenceChecker extends LightningElement {
    // Properties to store text in left and right panels
    leftPanelText = '';
    rightPanelText = '';
    isdiff = false;

    // Handle input changes in the left panel
    handleLeftPanelInput(event) {
        this.leftPanelText = event.target.innerText;
    }

    // Handle input changes in the right panel
    handleRightPanelInput(event) {
        this.rightPanelText = event.target.innerText;
    }

    // Compare text in the left and right panels
    compareText() {

        this.isdiff = false;

        // Split text into lines for comparison
        const leftLines = this.leftPanelText.split('\n');
        const rightLines = this.rightPanelText.split('\n');

        // Clear previous content in the left panel
        const leftContainer = this.template.querySelectorAll('.slds-panel__body.editable-content')[0];
        leftContainer.innerHTML = '';

        // Clear previous content in the right panel
        const rightContainer = this.template.querySelectorAll('.slds-panel__body.editable-content')[1];
        rightContainer.innerHTML = '';

        // Loop through each line and highlight differences
        for (let i = 0; i < Math.max(leftLines.length, rightLines.length); i++) {
            const leftLine = leftLines[i] || '';
            const rightLine = rightLines[i] || '';

            // Create divs to display lines
            const leftDiv = document.createElement('div');
            leftDiv.className = 'line-container';

            const rightDiv = document.createElement('div');
            rightDiv.className = 'line-container';

            // Check if the entire line is different
            if (leftLine !== rightLine) {

                this.isdiff = true;

                // Highlight differences with background color
                leftDiv.style.backgroundColor = 'rgba(255, 0, 0, 0.2)';
                leftDiv.style.marginBottom = '5px';

                rightDiv.style.backgroundColor = 'rgba(0, 255, 0, 0.2)';
                rightDiv.style.marginBottom = '5px';
            }

            // Display the entire line in left panel
            leftDiv.appendChild(document.createTextNode(leftLine));
            leftContainer.appendChild(leftDiv);

            // Display the entire line in right panel
            rightDiv.appendChild(document.createTextNode(rightLine));
            rightContainer.appendChild(rightDiv);
        }

        // Create arrow buttons for unsimilar lines
       //this.createArrowButtons();
    }


    merge(){

        this.leftPanelText = this.rightPanelText;
        this.compareText();
    }

    // Create arrow buttons for unsimilar lines
    createArrowButtons() {
        const comparisonContainer = this.template.querySelectorAll('.slds-panel__body.editable-content')[1];

        // Select lines with differences
        const unsimilarLines = comparisonContainer.querySelectorAll('.line-container[style*="background-color: rgba(0, 255, 0, 0.2)"]');

        // Add arrow buttons to unsimilar lines
        unsimilarLines.forEach((lineDiv, index) => {
            const arrowButton = document.createElement('button');
            arrowButton.innerHTML = '⬅'; // Unicode character for a left arrow
            arrowButton.className = 'arrow-button';
            arrowButton.style.background = '#e0e0e0'; // Set your desired background color
            
            // Add click event to update left panel text and re-run comparison
            arrowButton.addEventListener('click', () => {
                this.leftPanelText = this.rightPanelText;
                this.compareText();
            });

            lineDiv.insertBefore(arrowButton, lineDiv.firstChild);
        });

            
    }
}