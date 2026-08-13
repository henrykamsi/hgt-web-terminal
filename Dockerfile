FROM ubuntu:22.04

# Non-interactive installation setup
ENV DEBIAN_FRONTEND=noninteractive

# Pre-install essential developer packages, tmux, git, node, python
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    iputils-ping \
    git \
    vim \
    nano \
    tmux \
    python3 \
    python3-pip \
    nodejs \
    npm \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Add startup branding banner (MOTD)
RUN echo 'echo -e "\e[1;33m=====================================================\e[0m"' >> /etc/bash.bashrc && \
    echo 'echo -e "\e[1;32m Welcome to HGT Linux Cloud Environment v1.2.0        \e[0m"' >> /etc/bash.bashrc && \
    echo 'echo -e "\e[1;36m Owned by Henry Global Tech Industry [HGT]             \e[0m"' >> /etc/bash.bashrc && \
    echo 'echo -e "\e[1;33m Type \$hgt~aboutus or \$hgt~getversion to start        \e[0m"' >> /etc/bash.bashrc && \
    echo 'echo -e "\e[1;33m=====================================================\e[0m"' >> /etc/bash.bashrc && \
    echo 'export PS1="\[\033[01;32m\]hgt-linux\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /etc/bash.bashrc

# Copy custom command scripts into executable path
RUN echo '#!/bin/bash\necho -e "\e[1;32mLinux Version: 1.2.0\e[0m"' > /usr/local/bin/\$hgt~getversion && \
    echo '#!/bin/bash\necho -e "\e[1;36m=====================================================\e[0m\n\e[1;33mThis Linux Is Owned By Henry Global Tech Industry [HGT].\e[0m\n\e[1;36m=====================================================\e[0m\necho -e \"Visit This Link To Know More About HGT:\n\e]8;;https://henrykamsi.github.io/HGT-ABOUT-US-PAGE/\e\\\\https://henrykamsi.github.io/HGT-ABOUT-US-PAGE/\e]8;;\e\\\\"' > /usr/local/bin/\$hgt~aboutus && \
    echo '#!/bin/bash\necho -e "\e[1;33mUpdating HGT Linux System Packages...\e[0m"\napt-get update -y && apt-get upgrade -y > /dev/null 2>&1\nif [ $? -eq 0 ]; then echo -e "\e[1;32mLin~env~updated~SUCESS\e[0m"; else echo -e "\e[1;31mOFFLINE\e[0m⛈ Network Connect Poor / Update Failed"; fi' > /usr/local/bin/cd~package.upgrad\$ && \
    echo '#!/bin/bash\nping -c 1 8.8.8.8 > /dev/null 2>&1\nif [ $? -eq 0 ]; then echo -e "\e[1;32m>>online<<>>internet <Sucess><>\e[0m"; else echo -e "\e[1;31mOFFLINE⛈ Network Connect Poor\e[0m"; fi' > /usr/local/bin/~get.conection.online && \
    echo '#!/bin/bash\necho -e "\e[1;34mOptimizing session memory allocation...\e[0m"\nsync; echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true\necho -e "\e[1;32mMemory Optimization Complete!\e[0m"' > /usr/local/bin/cd~cd\$ && \
    echo '#!/bin/bash\necho -e "\e[1;33mContact Email:\e[0m Kamsih924@gmail.com"' > /usr/local/bin/hgt.get~email~\$

# Give executable permissions to all custom commands
RUN chmod +x /usr/local/bin/\$hgt~getversion \
             /usr/local/bin/\$hgt~aboutus \
             /usr/local/bin/cd~package.upgrad\$ \
             /usr/local/bin/~get.conection.online \
             /usr/local/bin/cd~cd\$ \
             /usr/local/bin/hgt.get~email~\$

# Set working directory
WORKDIR /home/user/workspace

CMD ["/bin/bash"]
