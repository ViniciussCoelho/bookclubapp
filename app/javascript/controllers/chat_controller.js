import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import { escapeHtml, formatDateTime, isCurrentUser, scrollToBottom } from "../helpers/chat_helper"

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
    const userIsCurrentUser = isCurrentUser(data.user_id)
    
    const messageElement = document.createElement('div')
    messageElement.className = `mb-4 ${userIsCurrentUser ? 'text-right' : ''}`
    messageElement.innerHTML = `
      <div class="${userIsCurrentUser ? 'bg-[#F9EDEF] ml-12' : 'bg-gray-100 mr-12'} inline-block rounded-lg px-4 py-2 max-w-sm">
        <div class="font-semibold text-sm mb-1 ${userIsCurrentUser ? 'text-[#8B2635]' : 'text-gray-800'}">
          ${userIsCurrentUser ? 'Você' : escapeHtml(data.user_name)}
        </div>
        <div class="text-gray-800">${escapeHtml(data.message)}</div>
        <div class="text-xs text-gray-500 mt-1">${formatDateTime(data.timestamp)}</div>
      </div>
    `
    messages.appendChild(messageElement)
    this.scrollToBottom()
  }

  scrollToBottom() {
    const messages = this.element.querySelector("#messages")
    scrollToBottom(messages)
  }
}