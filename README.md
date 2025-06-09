# Tokenized Retail Inventory Optimization System

A comprehensive blockchain-based inventory management system built on the Stacks blockchain using Clarity smart contracts. This system provides retailers with automated inventory tracking, demand forecasting, replenishment automation, and shrinkage prevention capabilities.

## 🚀 Features

### Core Contracts

1. **Retailer Verification Contract** (`retailer-verification.clar`)
    - Validates and manages retail business registrations
    - Tracks retailer reputation scores
    - Provides verification status for trusted retailers

2. **Inventory Tracking Contract** (`inventory-tracking.clar`)
    - Real-time inventory level monitoring
    - Stock movement tracking (IN/OUT/INITIAL)
    - Threshold-based alerts for low stock
    - Historical movement records

3. **Demand Forecasting Contract** (`demand-forecasting.clar`)
    - Predictive analytics for product demand
    - Seasonal adjustment factors
    - Trend analysis and confidence scoring
    - Historical sales data management

4. **Replenishment Automation Contract** (`replenishment-automation.clar`)
    - Automated reorder point management
    - Supplier catalog integration
    - Purchase order generation
    - Lead time and pricing optimization

5. **Shrinkage Prevention Contract** (`shrinkage-prevention.clar`)
    - Inventory variance detection
    - Shrinkage recording and investigation
    - Alert system for threshold breaches
    - Loss prevention analytics

## ��� Prerequisites

- Stacks blockchain node or testnet access
- Clarity CLI for contract deployment
- Node.js and npm for testing

## 🛠️ Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-retail-inventory
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## 🚀 Deployment

Deploy contracts to Stacks testnet:

\`\`\`bash
# Deploy retailer verification contract
clarinet deploy --testnet contracts/retailer-verification.clar

# Deploy inventory tracking contract
clarinet deploy --testnet contracts/inventory-tracking.clar

# Deploy demand forecasting contract
clarinet deploy --testnet contracts/demand-forecasting.clar

# Deploy replenishment automation contract
clarinet deploy --testnet contracts/replenishment-automation.clar

# Deploy shrinkage prevention contract
clarinet deploy --testnet contracts/shrinkage-prevention.clar
\`\`\`

## 📖 Usage Examples

### Register a Retailer

\`\`\`clarity
(contract-call? .retailer-verification register-retailer "Tech Store Inc" "Electronics")
\`\`\`

### Add Inventory Item

\`\`\`clarity
(contract-call? .inventory-tracking add-product u1 u1001 "iPhone 15" u50 u10 u100 u800)
\`\`\`

### Set Replenishment Rules

\`\`\`clarity
(contract-call? .replenishment-automation set-replenishment-rule u1 u1001 true u15 u30 u7 u1)
\`\`\`

### Record Sales Data

\`\`\`clarity
(contract-call? .demand-forecasting record-sales-data u1 u1001 u1 u25 u1000 u1100 u120)
\`\`\`

### Set Shrinkage Thresholds

\`\`\`clarity
(contract-call? .shrinkage-prevention set-shrinkage-thresholds u1 u1001 u5 u20 u50)
\`\`\`

## 🔧 Configuration

### Environment Variables

Create a \`.env\` file with the following variables:

\`\`\`
STACKS_NETWORK=testnet
CONTRACT_DEPLOYER_KEY=your-private-key
STACKS_API_URL=https://stacks-node-api.testnet.stacks.co
\`\`\`

### Contract Parameters

Each contract includes configurable parameters:

- **Thresholds**: Minimum/maximum stock levels
- **Time periods**: Forecasting windows, reorder frequencies
- **Costs**: Unit prices, transaction fees
- **Alerts**: Notification triggers and severity levels

## 🧪 Testing

The system includes comprehensive test suites using Vitest:

\`\`\`bash
# Run all tests
npm test

# Run specific contract tests
npm test -- retailer-verification
npm test -- inventory-tracking
npm test -- demand-forecasting
npm test -- replenishment-automation
npm test -- shrinkage-prevention
\`\`\`

## 📊 Monitoring and Analytics

### Key Metrics Tracked

- **Inventory Turnover**: Stock movement velocity
- **Forecast Accuracy**: Prediction vs. actual demand
- **Shrinkage Rates**: Loss percentages by category
- **Reorder Efficiency**: Automated vs. manual orders
- **Supplier Performance**: Lead times and reliability

### Dashboard Integration

The contracts provide read-only functions for dashboard integration:

- \`get-inventory-item\`: Current stock levels
- \`get-forecast\`: Demand predictions
- \`get-shrinkage-record\`: Loss tracking
- \`get-purchase-order\`: Order status

## 🔒 Security Features

- **Access Control**: Role-based permissions
- **Data Validation**: Input sanitization and bounds checking
- **Audit Trail**: Immutable transaction history
- **Error Handling**: Comprehensive error codes and messages

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the GitHub repository
- Join our Discord community
- Check the documentation wiki

## 🗺️ Roadmap

- [ ] Mobile app integration
- [ ] Advanced ML forecasting models
- [ ] Multi-chain support
- [ ] IoT sensor integration
- [ ] Real-time dashboard
- [ ] API gateway development

---

Built with ❤️ using Stacks blockchain and Clarity smart contracts.
\`\`\`
