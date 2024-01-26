# Como configurar o etc\hosts no Windows

Abra o Terminal pressionando shift + botão direito do mouse, vai aparecer este menu, clique `Executar como administrador`

![Menu do Windows Terminal com o shift + botão direito do mouse pressionados](menu1.jpg "Menu do Windows Terminal com o shift + botão direito do mouse pressionados").

Abra uma aba com o `Prompt de comando`
![Menu de abas do aba do Windows Terminal](menu2.jpg "Menu de abas do aba do Windows Terminal").

Estando no `cmd.exe`, como Administrador, execute o comando:

```dos
echo "127.0.0.2 ava" >> c:\Windows\System32\drivers\etc\hosts
```
