<div align="center">
  <img src="./images/logo.jpg", height=200></img>
  <h1>Six Guys Application</h1>
  Mobile Application For Automatic Inserting Sales Order In ERPNext.<br/>
  This includes <b>OpenAI's GPT 3.5 and ERPNext REST API.</b>
</div>
<br/>
    
> You must enter your OpenAI API Key

## Installation & Configuration

### From source

```bash
git clone https://github.com/irvine-sixguys/sales-order-app
cd sales-order-app
```

### Configure ChatGPT API

```bash
# on the project root
echo OPENAI_API_KEY=paste-your-openai-api-key-here > .env
```

## Getting Started

```bash
# you need flutter installed.
flutter run
```

## Techinques

### 📑 Adaptive Few-shot learning

> This application uses ChatGPT for parsing purchase order documents into sales order data.  
> Following results are shown in the second attempt of the Demo.

After the OCR process, we use few-shot learning techniques for increased accuracy in parsing data into the submittion form.  
Previous LLM query history are stored inside the app's local storage, used as the few-shot example for future template parsing attempts.  
As more queries gather, the OCR parsing accuracy & performances are enhanced.

<img height=500 src="https://github.com/irvine-sixguys/sales-order-app/assets/51053567/d14d303f-38bc-4c6c-a50a-3260101ab603"></img>

### 📷 OCR

This app uses Google's MLKit for OCR. MLKit uses the internal OCR API inside the mobile device. MLKit and the phone's native OCR features showed better performance & accuracy compared to the competitors (`pytesseract`, `tesseract.js`).

## Architecture

<img height=500 src="https://github.com/irvine-sixguys/sales-order-app/assets/51053567/cbdd61af-4ac1-4591-9004-d5aed516242f"/>

## Data Design

Following classes are the required fields of ERPNext sales order API.

```dart
class SalesOrderItem {
  final String itemCode;
  final String deliveryDate;
  final double qty;
  final double rate;

  ...
}

class SalesOrder {
  final String customer;
  final String transactionDate;
  final String currency;
  final String sellingPriceList;
  final List<SalesOrderItem> items;

  ...
}
```

Followings are the prompts used in `Parsing module`.

> First, the prompt for first attempt:

```plain
Following is the sales order format:
{
    "data": {
        "customer": "Yany", // 필수
        "transaction_date": "2024-01-15",
        "currency": "USD",
        "selling_price_list": "Standard Selling",
        "items": [
            {
                "item_code": "777",
                "delivery_date": "2024-01-16",
                "qty": 1.0,
                "rate": 5.0
            },
            {
                "item_code": "777",
                "delivery_date": "2024-01-16",
                "qty": 2.0,
                "rate": 5.0
            }
        ]
    }
}
---
Return the sales order details for the following OCR result:
[[this is OCR result for a purchase order document.]]
```

> Second, the prompt for second, third, ... attempts:

```plain
---
Return the sales order details for the following OCR result:
[[OCR result of stored example 1]]
{
    "data": ...
}
---
...
---
Return the sales order details for the following OCR result:
[[OCR result of stored example n]]
{
    "data": ...
}
---
Return the sales order details for the following OCR result:
[[this is OCR result for a purchase order document.]]
```

## Flow Diagram

<img height=900 src="https://github.com/irvine-sixguys/sales-order-app/assets/51053567/8b3ef814-c9e1-4654-a152-d6333aa8a208"></img>

## Interface

<img height=500 src="https://github.com/irvine-sixguys/sales-order-app/assets/51053567/fa2487a6-bf98-4f32-9d89-0b45df4221ba"></img>

## Features

### Activate ERPNext Connection

![login](https://github.com/irvine-sixguys/sales-order-app/assets/51053567/6211edba-ae4a-4e7e-a648-04d158b3c095)

### Parse OCR result using LLM (Adaptive Few-shot learning)

#### First attempt (Customer name is not recognized properly.)

![first](https://github.com/irvine-sixguys/sales-order-app/assets/51053567/1c0f2336-e060-4953-ac67-163a17e40f43)

#### Second attempt (Customer name is now properly recognized.)

![second](https://github.com/irvine-sixguys/sales-order-app/assets/51053567/d7496b0b-f2e3-4878-a8b5-36e49f865153)

## Security Design

This app uses Google MLKit to prevent documentation data being exposed to public internet. The next goal for this project is to use a private LLM to minimize the exposure of the inserted data.
