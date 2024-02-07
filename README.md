<div align="center">
  <img src="./images/logo.jpg"></img>
  <h1> Six Guys</h1>
  Mobile Application For Automatic Inserting Sales Order In ERPNext.
</div>
<br/>
This includes **OpenAI's GPT 3.5 and ERPNext API**.


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

## Start
```bash
flutter run
```

## Features

### Activate ERPNext Connection
![login](https://github.com/irvine-sixguys/sales-order-app/assets/51053567/6211edba-ae4a-4e7e-a648-04d158b3c095)

### Parse OCR result using LLM (Adaptive Few-shot learning)
#### First attempt (Customer name is not recognized properly.)
![first](https://github.com/irvine-sixguys/sales-order-app/assets/51053567/1c0f2336-e060-4953-ac67-163a17e40f43)

#### Second attempt (Customer name is now properly recognized.)
![second](https://github.com/irvine-sixguys/sales-order-app/assets/51053567/d7496b0b-f2e3-4878-a8b5-36e49f865153)
