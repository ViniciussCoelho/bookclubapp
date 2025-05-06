import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  connect() {
    this.setupMutationObserver()
    this.setupSubscription()
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

  setupSubscription() {
    if (this.hasSubscription) return

    this.consumer = createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      {
        channel: this.element.dataset.channel,
        club_id: this.element.dataset.clubId
      },
      {
        received: data => {
          const messagesContainer = this.element.querySelector("#messages")
          if (messagesContainer) {
            messagesContainer.innerHTML = data.html
            this.scrollToBottom()
          }
        }
      }
    )

    this.hasSubscription = true
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }
} 