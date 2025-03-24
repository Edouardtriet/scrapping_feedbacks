import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    console.log("Search controller connected")
    this.resultsTarget.style.display = "none"
  }

  handleKeydown(event) {
    // If Enter is pressed
    if (event.key === "Enter") {
      // If there are no results or the dropdown is hidden, let the form submit normally
      // The controller will handle showing the cheeky message
      if (this.resultsTarget.style.display === "none" || this.resultsTarget.children.length === 0) {
        return
      }

      // If dropdown is visible, click the first result instead
      event.preventDefault()
      const firstResult = this.resultsTarget.querySelector(".search-result-item a")
      if (firstResult) {
        firstResult.click()
      }
    }
  }

  suggest() {
    const query = this.inputTarget.value

    if (query.length < 2) {
      this.resultsTarget.style.display = "none"
      return
    }

    fetch(`/searches/suggestions?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.innerHTML = ""
        this.resultsTarget.style.display = data.length > 0 ? "block" : "none"

        data.forEach(app => {
          const item = document.createElement("div")
          item.className = "search-result-item"

          item.innerHTML = `
            <a href="/searches/${app.id}/countries" class="d-flex align-items-center p-2">
              <img src="${app.icon || '/default_app_icon.png'}" alt="${app.name}" width="40" height="40" class="me-3 rounded">
              <div>
                <div class="app-name">${app.name}</div>
                <div class="app-developer text-muted">${app.developer || ''}</div>
              </div>
            </a>
          `

          this.resultsTarget.appendChild(item)
        })
      })
  }
}
