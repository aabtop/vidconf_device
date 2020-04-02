import re
import sys

host_names = sys.argv[1].strip().split(' ')
guac_login_password = sys.argv[2]
output_html_file = sys.argv[3]

IS_IP4 = re.compile(r"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")

ipv4_host_names = [x for x in host_names if IS_IP4.match(x)]

address_items_str = '\n'.join(
    ['<div>https://{0}</div>'.format(x) for x in ipv4_host_names])

with open("vidconf_wallpaper.template.html") as f:
  template_contents = f.read()

with open(output_html_file, "w") as f:
  f.write(template_contents.format(address_items=address_items_str,
                                   login_password=guac_login_password))
