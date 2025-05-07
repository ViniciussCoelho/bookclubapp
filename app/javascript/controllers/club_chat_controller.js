import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setupMutationObserver()
    this.scrollToBottom()
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }

  setupMutationObserver() {
    const observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    observer.observe(this.element, {
      childList: true,
      subtree: true
    })
  }
} 