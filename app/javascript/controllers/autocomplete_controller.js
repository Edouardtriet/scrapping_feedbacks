import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "suggestions" ]

  connect() {
    // Add event listener for clicking on suggestions
    this.suggestionsTarget.addEventListener('click', this.selectSuggestion.bind(this))
  }

  search(event) {
    const query = event.target.value

    if (query.length < 2) {
      this.suggestionsTarget.innerHTML = ''
      return
    }

    fetch(`/searches/autocomplete?query=${query}`, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(suggestions => {
      this.renderSuggestions(suggestions)
    })
    .catch(error => {
      console.error('Error fetching suggestions:', error)
    })
  }

  renderSuggestions(suggestions) {
    const suggestionsHtml = suggestions.map((app, index) =>
      `<div class="autocomplete-suggestions-item" data-index="${index}">${app}</div>`
    ).join('')

    this.suggestionsTarget.innerHTML = suggestionsHtml
  }

  selectSuggestion(event) {
    if (event.target.classList.contains('autocomplete-suggestions-item')) {
      this.inputTarget.value = event.target.textContent
      this.suggestionsTarget.innerHTML = ''
    }
  }

  handleKeydown(event) {
    const suggestions = this.suggestionsTarget.querySelectorAll('.autocomplete-suggestions-item')

    switch(event.key) {
      case 'ArrowDown':
        this.moveFocus(suggestions, 1)
        event.preventDefault()
        break
      case 'ArrowUp':
        this.moveFocus(suggestions, -1)
        event.preventDefault()
        break
      case 'Enter':
        const focusedSuggestion = this.suggestionsTarget.querySelector('.focused')
        if (focusedSuggestion) {
          this.inputTarget.value = focusedSuggestion.textContent
          this.suggestionsTarget.innerHTML = ''
        }
        break
      case 'Escape':
        this.suggestionsTarget.innerHTML = ''
        break
    }
  }

  moveFocus(suggestions, direction) {
    if (suggestions.length === 0) return

    // Remove previous focus
    suggestions.forEach(el => el.classList.remove('focused'))

    // Find currently focused or start from the beginning
    const currentIndex = Array.from(suggestions).findIndex(el => el.classList.contains('focused'))

    let newIndex = currentIndex + direction

    // Wrap around if needed
    if (newIndex >= suggestions.length) newIndex = 0
    if (newIndex < 0) newIndex = suggestions.length - 1

    // Add focus to new suggestion
    suggestions[newIndex].classList.add('focused')
  }
}
