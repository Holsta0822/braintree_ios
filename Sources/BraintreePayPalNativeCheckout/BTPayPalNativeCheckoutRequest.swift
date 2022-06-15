import BraintreePayPal

/**
 Options for the PayPal Checkout and PayPal Checkout with Vault flows.
 */
@objc public class BTPayPalNativeCheckoutRequest: BTPayPalCheckoutRequest, BTPayPalNativeRequest {

    let paymentType: BTPayPalPaymentType = .checkout

    /**
     Initializes a PayPal Checkout request.

     - Parameter amount: Used for a one-time payment. Amount must be greater than or equal to zero, may optionally contain exactly 2 decimal places separated by '.' and is limited to 7 digits before the decimal point.

     - Returns: A PayPal Checkout request.
     */
    @objc public override init(amount: String) {
        self.hermesPath = "v1/paypal_hermes/create_payment_resource"
        super.init(amount: amount)
    }

    // MARK: - Internal

    let hermesPath: String

    var intentAsString: String {
        switch intent {
        case .sale:
            return "sale"
        case .order:
            return "order"
        default:
            return "authorize"
        }
    }

    func parameters(with configuration: BTConfiguration) -> [AnyHashable: Any] {
        let baseParams = getBaseParameters(with: configuration)

        let billingAgreementDictionary: [AnyHashable: Any]? = {
            if let description = billingAgreementDescription {
                return ["description": description]
            }
            else {
                return nil
            }
        }()

        let paypalParams = [
            // Values from BTPayPalCheckoutRequest
            "intent": intentAsString,
            "amount": amount,
            "offer_pay_later": offerPayLater,
            "currency_iso_code": currencyCode ?? configuration.json["paypal"]["currencyIsoCode"].asString(),
            "request_billing_agreement": requestBillingAgreement ? true : nil,
            "billing_agreement_details": requestBillingAgreement ? billingAgreementDictionary : nil,
            "line1": shippingAddressOverride?.streetAddress,
            "line2": shippingAddressOverride?.extendedAddress,
            "city": shippingAddressOverride?.locality,
            "state": shippingAddressOverride?.region,
            "postal_code": shippingAddressOverride?.postalCode,
            "country_code": shippingAddressOverride?.countryCodeAlpha2,
            "recipient_name": shippingAddressOverride?.recipientName,
        ].compactMapValues { $0 }

        // Combining the base parameters with the parameters defined here - if there is a conflict,
        // choose the values defined here
        return baseParams.merging(paypalParams, uniquingKeysWith: { _, new in new })
    }
}