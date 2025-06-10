;; Demand Forecasting Contract
;; Forecasts product demand based on historical data

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_NOT_FOUND (err u301))
(define-constant ERR_INVALID_DATA (err u302))

;; Data structures
(define-map demand-history
  { retailer-id: uint, product-id: uint, period: uint }
  {
    sales-quantity: uint,
    period-start: uint,
    period-end: uint,
    seasonal-factor: uint
  }
)

(define-map demand-forecasts
  { retailer-id: uint, product-id: uint }
  {
    predicted-demand: uint,
    confidence-level: uint,
    forecast-period: uint,
    last-calculated: uint,
    trend-direction: (string-ascii 10)
  }
)

;; Public functions
(define-public (record-sales-data (retailer-id uint) (product-id uint) (period uint)
                                 (sales-quantity uint) (period-start uint) (period-end uint) (seasonal-factor uint))
  (begin
    (asserts! (> sales-quantity u0) ERR_INVALID_DATA)
    (asserts! (< period-start period-end) ERR_INVALID_DATA)
    (asserts! (<= seasonal-factor u200) ERR_INVALID_DATA)

    (map-set demand-history
      { retailer-id: retailer-id, product-id: product-id, period: period }
      {
        sales-quantity: sales-quantity,
        period-start: period-start,
        period-end: period-end,
        seasonal-factor: seasonal-factor
      }
    )
    (ok true)
  )
)

(define-public (calculate-forecast (retailer-id uint) (product-id uint) (forecast-period uint))
  (let ((base-demand (get-average-demand retailer-id product-id)))
    (let ((seasonal-adjustment (get-seasonal-adjustment retailer-id product-id))
          (trend-factor (get-trend-factor retailer-id product-id)))
      (let ((predicted-demand (/ (* (* base-demand seasonal-adjustment) trend-factor) u10000))
            (confidence (calculate-confidence retailer-id product-id)))

        (map-set demand-forecasts
          { retailer-id: retailer-id, product-id: product-id }
          {
            predicted-demand: predicted-demand,
            confidence-level: confidence,
            forecast-period: forecast-period,
            last-calculated: block-height,
            trend-direction: (if (> trend-factor u100) "UP" "DOWN")
          }
        )
        (ok predicted-demand)
      )
    )
  )
)

;; Private helper functions
(define-private (get-average-demand (retailer-id uint) (product-id uint))
  ;; Simplified calculation - in reality would analyze multiple periods
  (match (map-get? demand-history { retailer-id: retailer-id, product-id: product-id, period: u1 })
    history (get sales-quantity history)
    u10
  )
)

(define-private (get-seasonal-adjustment (retailer-id uint) (product-id uint))
  ;; Simplified seasonal factor
  (match (map-get? demand-history { retailer-id: retailer-id, product-id: product-id, period: u1 })
    history (get seasonal-factor history)
    u100
  )
)

(define-private (get-trend-factor (retailer-id uint) (product-id uint))
  ;; Simplified trend calculation
  u105
)

(define-private (calculate-confidence (retailer-id uint) (product-id uint))
  ;; Simplified confidence calculation
  u75
)

;; Read-only functions
(define-read-only (get-forecast (retailer-id uint) (product-id uint))
  (map-get? demand-forecasts { retailer-id: retailer-id, product-id: product-id })
)

(define-read-only (get-sales-history (retailer-id uint) (product-id uint) (period uint))
  (map-get? demand-history { retailer-id: retailer-id, product-id: product-id, period: period })
)

(define-read-only (get-predicted-demand (retailer-id uint) (product-id uint))
  (match (map-get? demand-forecasts { retailer-id: retailer-id, product-id: product-id })
    forecast (some (get predicted-demand forecast))
    none
  )
)
