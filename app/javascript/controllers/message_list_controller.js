import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Scroll to selected message on page load, with a delay to ensure threads are expanded
    setTimeout(() => {
      const selected = this.element.querySelector('.message-selected')
      if (selected) {
        selected.scrollIntoView({behavior: 'smooth', block: 'center'})
      }
    }, 100)
  }

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
