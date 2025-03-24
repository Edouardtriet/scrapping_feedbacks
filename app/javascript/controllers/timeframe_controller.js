import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateContainer", "allTime", "customRange", "dateInput"]

  connect() {
    console.log("Timeframe controller connected")
    this.toggleDateRange()
  }

  toggleDateRange() {
    if (this.customRangeTarget.checked) {
      this.dateContainerTarget.classList.remove('d-none')
      this.dateInputTargets.forEach(input => {
        input.disabled = false
      })
    } else {
      this.dateContainerTarget.classList.add('d-none')
      this.dateInputTargets.forEach(input => {
        input.disabled = true
      })
    }
  }

  validateDates(event) {
    if (this.customRangeTarget.checked) {
      const startDate = new Date(this.dateInputTargets[0].value)
      const endDate = new Date(this.dateInputTargets[1].value)

      if (startDate > endDate) {
        event.preventDefault()
        alert('Start date cannot be after end date')
      }
    }
  }
}
