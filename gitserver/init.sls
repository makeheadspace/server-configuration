git:
  user.present:
    - shell: /bin/bash
  pkg.installed:
    - names:
      - git
      - gitolite
  file.append:
    - name: /home/git/.bashrc
    - text: PATH=$HOME/bin:$PATH
    - require:
      - user: git
