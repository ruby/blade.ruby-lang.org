import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
    document.addEventListener('keydown', this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener('keydown', this.handleKeydown)
  }

  handleKeydown(event) {
    // Don't trigger if user is typing in an input field
    if (event.target.matches('input, textarea, select')) {
      return
    }

    const key = event.key.toLowerCase()

    // Define key mappings
    const keyMappings = {
      // Arrow keys
      'arrowup': 'prev-thread',
      'arrowdown': 'next-thread',
      'arrowleft': 'prev-message',
      'arrowright': 'next-message',
      // Vim-style (only when Ctrl is not pressed)
      'k': !event.ctrlKey ? 'prev-thread' : null,
      'j': !event.ctrlKey ? 'next-thread' : null,
      'h': !event.ctrlKey ? 'prev-message' : null,
      'l': !event.ctrlKey ? 'next-message' : null,
      // Emacs-style (only when Ctrl is pressed)
      'p': event.ctrlKey ? 'prev-thread' : null,
      'n': event.ctrlKey ? 'next-thread' : null,
      'b': event.ctrlKey ? 'prev-message' : null,
      'f': event.ctrlKey ? 'next-message' : null,
    }

    const navAction = keyMappings[key]
    if (!navAction) return

    const link = this.element.querySelector(`[data-nav="${navAction}"]`)
    if (link && !link.classList.contains('cursor-not-allowed')) {
      event.preventDefault()
      link.click()
    }
  }
}
