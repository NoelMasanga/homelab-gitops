# SANITIZE — clean-export policy

Every repo here is a **public-facing, sanitized** export. Before anything is staged:

## Always remove
- API tokens, PATs, OAuth secrets, `.env`, credential files (`*.key`, `*.pem`, `*.crt`, `id_*`, `*.keystore`)
- Passwords, private IPs/hostnames/domain configs that reveal the private network, MAC addresses, serials
- Personal identifiers beyond name + professional contact email
- Stray temp/cache files (`~$*`, `*.log`, `data/`, `output/`)

## Keep
- Generic, non-sensitive architecture/design that demonstrates skill
- Code/steps with placeholders (`<vmid>`, `example.com`, `10.0.0.0/24-range-only`)

## Check before commit
- `git status` clean of the above
- `rg -i "token|secret|password|BEGIN .*PRIVATE"` returns nothing sensitive
- `.gitignore` present and effective
