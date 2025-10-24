import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    // Remove highlight from previously selected message
    const previousSelected = this.element.querySelector('.message-selected')
    if (previousSelected) {
      previousSelected.classList.remove('message-selected')
    }

    // Add highlight to clicked message
    const messageElement = event.currentTarget
    if (messageElement) {
      messageElement.classList.add('message-selected')
    }
  }
}
