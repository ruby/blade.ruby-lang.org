import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="thread"
export default class extends Controller {
  static targets = ["children", "icon"]

  connect() {
    // Initially hide children unless one is selected
    if (this.hasChildrenTarget) {
      const hasSelectedChild = this.childrenTarget.querySelector('.message-selected')
      if (hasSelectedChild) {
        // Keep expanded and rotate icon
        if (this.hasIconTarget) {
          this.iconTarget.classList.add("rotate-90")
        }
      } else {
        this.childrenTarget.classList.add("hidden")
      }
    }
  }

  toggle() {
    if (this.hasChildrenTarget) {
      this.childrenTarget.classList.toggle("hidden")

      // Rotate the icon
      if (this.hasIconTarget) {
        this.iconTarget.classList.toggle("rotate-90")
      }
    }
  }
}
