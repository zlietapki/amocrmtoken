Get token for amoCRM api
========================

Run

```bash
rm -f init.json
./get_amocrm_token_from_init.sh
```

It will create template for token-init data

Create new api-integration at `https://your.amocrm.ru/settings/widgets/`

Fill `init.json` file with `redirect URI`, `secret key`, `integration ID`, `auth code` from created integration 

Don't forget to edit url and run again

```bash
./get_amocrm_token_from_init.sh https://your.amocrm.ru
```

Now `token.json` is created. That's it ready for use
