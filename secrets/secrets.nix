let
  hitsugibune = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUlhaAtSnpfDxyMy0MtplwbbO+Txgf2JuqHq2tqWh9g";
  saberofxebec = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZR0PabrqXBfD1NexkvifoJHraM+NOOxHDXLSUpnmGV root@saberofxebec";
  key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBQtMQF6NpN/tPS01LRAI1yIzfTj+tNQi+TsG7+dRSsTxxv4eXJ1EQ1HV5vSAYlCwt0FjlK2ejXUqXzGzZBdd2usPBYPHiE3n2ZfQ3bCPJVa17M/ZIgX2PB/CcewQSVMZmlNu2SoocGaOBSQ9CaGQYe8Cj2nrZxF6ArPEm7FcFTvV+nJa//nEXccM2gexEyuuPm/ESMbCB/sffz8xgeDpCgG97Hb8JDcEtw5n17ZzR0eSJlSGQ2Sv8rM0ymO9GwHIJgnvPBxLV1TTotAy8E2kQF84Z9/tPkrI2T30EPvOxCtbIHR/8ZCbasTWfyoM2+Gum63soxAdcvjbRbiQEwpO2KiEYl4Zu3n0FJqqJGnC3yVpK7zZfEw7djeX8PJOjt5xzyhTGyjkLREuO/1IwLN0vCdC9irjCWrdoPTDnYLPN4aYEbH19Ff1UiVFB/jAsIwKsMFJ66/EawrJ1MLcdhSbZv0wZgG4DByeBz148Ev7uidT7orpaqf/dCCYpHc8Kfys=";
in {
  "nextcloud.age".publicKeys = [hitsugibune key];
  "onlyoffice.age".publicKeys = [hitsugibune key];
  "speedtest-tracker.age".publicKeys = [saberofxebec key];
  "matrix.age".publicKeys = [hitsugibune key];
  "coturn.age".publicKeys = [hitsugibune key];
}
