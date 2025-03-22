import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectAll", "country"]

  connect() {
    console.log("Country selection controller connected")
    this.updateSelectAllCheckbox()
  }

  toggleSelectAll() {
    const isChecked = this.selectAllTarget.checked

    this.countryTargets.forEach(checkbox => {
      checkbox.checked = isChecked
    })
  }

  updateSelectAllCheckbox() {
    const allChecked = this.countryTargets.every(checkbox => checkbox.checked)

    // Set to checked only if ALL countries are checked, otherwise unchecked
    this.selectAllTarget.checked = allChecked

    // Don't use indeterminate state
    this.selectAllTarget.indeterminate = false
  }

  validateForm(event) {
    const anyChecked = this.countryTargets.some(checkbox => checkbox.checked)

    if (!anyChecked) {
      event.preventDefault()
      alert('Please select at least one country')
    }
  }
}
