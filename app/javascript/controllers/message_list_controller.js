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

    // Listen for turbo frame loads to update selection
    document.addEventListener('turbo:frame-load', this.handleFrameLoad.bind(this))
  }

  disconnect() {
    document.removeEventListener('turbo:frame-load', this.handleFrameLoad.bind(this))
  }

  handleFrameLoad(event) {
    if (event.target.id === 'message_content') {
      // Extract list_seq from the loaded message
      const messageElement = event.target.querySelector('[data-list-seq]')
      if (messageElement) {
        const listSeq = messageElement.dataset.listSeq
        // Find corresponding link in the left pane by matching the URL ending
        const correspondingLink = this.element.querySelector(`a[href$="/${listSeq}"]`)
        if (correspondingLink) {
          const messageItem = correspondingLink.closest('.message-item')

          // Check if this message is inside a collapsed thread
          const threadMessage = correspondingLink.closest('.thread-message')
          if (threadMessage) {
            const parentThreadMessage = threadMessage.parentElement.closest('[data-controller="thread"]')
            if (parentThreadMessage) {
              // Find the children container and expand it
              const childrenContainer = parentThreadMessage.querySelector('[data-thread-target="children"]')
              const icon = parentThreadMessage.querySelector('[data-thread-target="icon"]')
              if (childrenContainer && childrenContainer.classList.contains('hidden')) {
                childrenContainer.classList.remove('hidden')
                if (icon) {
                  icon.classList.add('rotate-90')
                }
              }
            }
          }

          this.selectMessage(messageItem)
          // Scroll to the selected message
          messageItem.scrollIntoView({behavior: 'smooth', block: 'center'})
        }
      }
    }
  }

  select(event) {
    this.selectMessage(event.currentTarget)
  }

  selectMessage(messageElement) {
    // Remove highlight from previously selected message
    const previousSelected = this.element.querySelector('.message-selected')
    if (previousSelected) {
      previousSelected.classList.remove('message-selected')
    }

    // Add highlight to clicked message
    if (messageElement) {
      messageElement.classList.add('message-selected')
    }
  }
}
