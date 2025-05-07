import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["input"]
  static values = {
    clubId: Number
  }
  
  connect() {
    this.setupActionCable()
    this.scrollToBottom()
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }

  setupActionCable() {
    this.consumer = createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      { 
        channel: "ClubChatChannel", 
        club_id: this.clubIdValue 
      },
      {
        received: this.messageReceived.bind(this)
      }
    )
  }

  send(event) {
    event.preventDefault()
    const message = this.inputTarget.value.trim()
    if (message === "") return

    this.subscription.send({ message })
    this.inputTarget.value = ""
    this.scrollToBottom()
  }

  messageReceived(data) {
    const messages = this.element.querySelector("#messages")
    const currentUserId = document.querySelector('meta[name="current-user-id"]')?.content
    const isCurrentUser = data.user_id.toString() === currentUserId
    
    const messageElement = document.createElement('div')
    messageElement.className = `mb-4 ${isCurrentUser ? 'text-right' : ''}`
    messageElement.innerHTML = `
      <div class="${isCurrentUser ? 'bg-[#F9EDEF] ml-12' : 'bg-gray-100 mr-12'} inline-block rounded-lg px-4 py-2 max-w-sm">
        <div class="font-semibold text-sm mb-1 ${isCurrentUser ? 'text-[#8B2635]' : 'text-gray-800'}">
          ${isCurrentUser ? 'Você' : data.user_name}
        </div>
        <div class="text-gray-800">${data.message}</div>
        <div class="text-xs text-gray-500 mt-1">${new Date(data.timestamp).toLocaleString('pt-BR', { hour: '2-digit', minute: '2-digit' })}</div>
      </div>
    `
    messages.appendChild(messageElement)
    this.scrollToBottom()
  }

  scrollToBottom() {
    const messages = this.element.querySelector("#messages")
    if (messages) {
      messages.scrollTop = messages.scrollHeight
    }
  }
}