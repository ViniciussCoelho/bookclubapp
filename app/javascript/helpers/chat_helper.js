export const escapeHtml = (unsafe) => {
  if (!unsafe) return ''
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;")
}

export const formatDateTime = (timestamp) => {
  return new Date(timestamp).toLocaleString('pt-BR', { 
    hour: '2-digit', 
    minute: '2-digit' 
  })
}

export const getCurrentUserId = () => {
  return document.querySelector('meta[name="current-user-id"]')?.content
}

export const isCurrentUser = (userId) => {
  return userId.toString() === getCurrentUserId()
}

export const scrollToBottom = (element) => {
  if (element) {
    element.scrollTop = element.scrollHeight
  }
}