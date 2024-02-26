import { LightningElement, track } from 'lwc';

    export default class SnakeDeploymentPath extends LightningElement {
        @track steps = [
            { id: 1, completed: false },
            { id: 2, completed: false },
            { id: 3, completed: false },
            { id: 4, completed: false }
        ];

        get stepClass() {
            return this.steps.findIndex(step => !step.completed) % 2 === 0
                ? 'step even'
                : 'step odd';
        }

        allowDrop(event) {
            event.preventDefault();
        }

        handleDrop(event) {
            event.preventDefault();
            const draggedStepId = event.dataTransfer.getData('text/plain');
            const droppedStepId = event.target.dataset.stepId;

            const draggedIndex = this.steps.findIndex(step => step.id.toString() === draggedStepId);
            const droppedIndex = this.steps.findIndex(step => step.id.toString() === droppedStepId);

            if (draggedIndex !== -1 && droppedIndex !== -1) {
                this.steps.splice(droppedIndex, 0, this.steps.splice(draggedIndex, 1)[0]);
            }
        }

        handleDragStart(event) {
            event.dataTransfer.setData('text/plain', event.target.dataset.stepId);
        }

        completeStep(event) {
            const clickedStepId = event.target.closest('.step').dataset.stepId;
            const index = this.steps.findIndex(step => step.id.toString() === clickedStepId);

            if (index !== -1) {
                this.steps[index].completed = true;
            }
        }
    }