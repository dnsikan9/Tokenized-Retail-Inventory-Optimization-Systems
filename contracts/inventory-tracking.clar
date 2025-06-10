;; Inventory Tracking Contract
;; Tracks retail inventory levels and movements

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_NOT_FOUND (err u201))
(define-constant ERR_INSUFFICIENT_STOCK (err u202))
(define-constant ERR_INVALID_QUANTITY (err u203))

;; Data structures
(define-map inventory-items
  { retailer-id: uint, product-id: uint }
  {
    product-name: (string-ascii 100),
    current-stock: uint,
    min-threshold: uint,
    max-capacity: uint,
    unit-cost: uint,
    last-updated: uint
  }
)

(define-map inventory-movements
  { movement-id: uint }
  {
    retailer-id: uint,
    product-id: uint,
    movement-type: (string-ascii 20),
    quantity: uint,
    timestamp: uint,
    reference: (string-ascii 100)
  }
)

(define-data-var next-movement-id uint u1)

;; Public functions
(define-public (add-product (retailer-id uint) (product-id uint) (product-name (string-ascii 100))
                           (initial-stock uint) (min-threshold uint) (max-capacity uint) (unit-cost uint))
  (begin
    (asserts! (> (len product-name) u0) ERR_INVALID_QUANTITY)
    (asserts! (<= min-threshold max-capacity) ERR_INVALID_QUANTITY)

    (map-set inventory-items
      { retailer-id: retailer-id, product-id: product-id }
      {
        product-name: product-name,
        current-stock: initial-stock,
        min-threshold: min-threshold,
        max-capacity: max-capacity,
        unit-cost: unit-cost,
        last-updated: block-height
      }
    )

    (if (> initial-stock u0)
      (unwrap-panic (record-movement retailer-id product-id "INITIAL" initial-stock "Initial stock"))
      true
    )
    (ok true)
  )
)

(define-public (update-stock (retailer-id uint) (product-id uint) (quantity uint) (movement-type (string-ascii 20)) (reference (string-ascii 100)))
  (let ((item (unwrap! (map-get? inventory-items { retailer-id: retailer-id, product-id: product-id }) ERR_NOT_FOUND)))
    (let ((new-stock
           (if (is-eq movement-type "IN")
             (+ (get current-stock item) quantity)
             (if (is-eq movement-type "OUT")
               (begin
                 (asserts! (>= (get current-stock item) quantity) ERR_INSUFFICIENT_STOCK)
                 (- (get current-stock item) quantity)
               )
               (get current-stock item)
             )
           )))

      (map-set inventory-items
        { retailer-id: retailer-id, product-id: product-id }
        (merge item { current-stock: new-stock, last-updated: block-height })
      )

      (unwrap-panic (record-movement retailer-id product-id movement-type quantity reference))
      (ok new-stock)
    )
  )
)

(define-private (record-movement (retailer-id uint) (product-id uint) (movement-type (string-ascii 20)) (quantity uint) (reference (string-ascii 100)))
  (let ((movement-id (var-get next-movement-id)))
    (map-set inventory-movements
      { movement-id: movement-id }
      {
        retailer-id: retailer-id,
        product-id: product-id,
        movement-type: movement-type,
        quantity: quantity,
        timestamp: block-height,
        reference: reference
      }
    )
    (var-set next-movement-id (+ movement-id u1))
    (ok movement-id)
  )
)

;; Read-only functions
(define-read-only (get-inventory-item (retailer-id uint) (product-id uint))
  (map-get? inventory-items { retailer-id: retailer-id, product-id: product-id })
)

(define-read-only (get-current-stock (retailer-id uint) (product-id uint))
  (match (map-get? inventory-items { retailer-id: retailer-id, product-id: product-id })
    item (some (get current-stock item))
    none
  )
)

(define-read-only (is-below-threshold (retailer-id uint) (product-id uint))
  (match (map-get? inventory-items { retailer-id: retailer-id, product-id: product-id })
    item (<= (get current-stock item) (get min-threshold item))
    false
  )
)

(define-read-only (get-movement (movement-id uint))
  (map-get? inventory-movements { movement-id: movement-id })
)
