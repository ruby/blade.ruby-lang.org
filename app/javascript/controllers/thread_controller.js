import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="thread"
export default class extends Controller {
  static targets = ["children", "icon"]

  connect() {
    // Initially hide children
    if (this.hasChildrenTarget) {
      this.childrenTarget.classList.add("hidden")
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
