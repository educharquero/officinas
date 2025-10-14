# LPIC-1 Tópico 102.1 - Design Hard Disk Layout

## Visão Geral

O tópico 102.1 da certificação LPIC-1 aborda o **planejamento de layout de disco rígido**, incluindo estratégias de particionamento, alocação de sistemas de arquivos e considerações sobre desempenho e segurança. Este conhecimento é essencial para administradores de sistemas Linux.

---

## 1. Conceitos Fundamentais

## Particionamento de Disco

- **Partições Primárias**: 
  - Máximo de 4 partições por disco (MBR)
  - Ocupam espaço contíguo no disco
- **Partições Estendidas**:
  - Permitem criar múltiplas partições lógicas
  - Uma das 4 partições primárias pode ser estendida
- **Partições Lógicas**:
  - Criadas dentro da partição estendida
  - Úteis para sistemas com mais de 4 partições

## Sistemas de Arquivos (Filesystems)

- **Ext4**: 
  - Padrão em distribuições modernas
  - Suporte a journaling, snapshots e alocação atrasada
- **XFS/Btrfs**: 
  - Alternativas para grandes volumes de dados
  - Recursos avançados (compressão, checksums)
- **Swap**: 
  - Área de memória virtual
  - Recomendado: 1-2x a RAM física

---

## 2. Planejamento de Layout

## Diretórios Críticos

| Diretório | Função               | Recomendações                                |
| --------- | -------------------- | -------------------------------------------- |
| `/`       | Raiz do sistema      | Mínimo 20-25 GB                              |
| `/home`   | Dados de usuários    | Separado para backups                        |
| `/var`    | Logs, caches, spools | Partição dedicada para evitar saturação      |
| `/tmp`    | Arquivos temporários | Separado para segurança (mount com `nosuid`) |
| `/boot`   | Kernel e bootloader  | Partição primária no início do disco         |

## Estratégias de Particionamento

1. **Layout Simples**:
   
   - Partição única (`/`) + swap
   - Adequado para sistemas pequenos/estáticos

2. **Layout Multifunção**:
   
   ```bash
   /        = 25 GB (ext4)
   /home    = 50 GB (ext4)
   /var     = 20 GB (ext4)
   /tmp     = 5 GB (ext4)
   swap     = 8 GB
   
     Layout Avançado:
         Partições separadas para /usr, /opt, /srv
         LVM para flexibilidade e redimensionamento
   ```

3. Considerações de Desempenho 
   Otimização de Acesso 
   
     Posicionamento Físico:
   
         Colocar /boot no início do disco (setores mais rápidos)
         Partições frequentemente acessadas próximas entre si
   
     Tamanho de Bloco:
   
         Blocos maiores (4KB) para arquivos grandes (mídia, bancos de dados)
         Blocos menores (1KB) para arquivos pequenos (sistemas de arquivos tradicionais)

## Segurança e Estabilidade:

Montagem com Opções Especiais:

/tmp    nosuid,nodev,noexec
/home   nodev
/var    nosuid

Separar Partições Críticas:

- Evita que logs (/var) ou dados de usuários (/home) comprometam o sistema principal
4. Gestão de Espaço 
   Previsão de Crescimento 
   
     Regra Geral:
   
         /var: 2-3x o espaço necessário inicial
         /home: 30-50% a mais que o uso atual
         Swap: Mínimo igual à RAM física (para hibernação)

Ferramentas de Monitoramento 

     df -h: Espaço em disco por partição
     du -sh */: Uso por diretório
     ncdu: Análise interativa de consumo

5. Boas Práticas 
   Checklist de Planejamento 
   
     Identificar requisitos de armazenamento
     Prever crescimento futuro (2-3 anos)
     Separar dados críticos do sistema
     Alocar espaço para /var e /tmp
     Definir política de backups
     Testar layout em ambiente de homologação

Armadilhas Comuns 

     Subestimar /var:
         Logs, caches e spools podem crescer rapidamente
    
     Ignorar /tmp:
         Preenchimento pode causar falhas em aplicações
    
     Partição única:
         Dificulta recuperação do sistema e backups

6. Exemplo Prático 
   Layout para Servidor Web

/dev/sda1   /boot    500M   ext4   (primária)
/dev/sda2   swap     4G     swap
/dev/sda3   /        20G    ext4
/dev/sda4   extended
  ├─/dev/sda5  /var    10G    ext4
  ├─/dev/sda6  /home   50G    ext4
  └─/dev/sda7  /tmp    2G     ext4

Opções de Montagem no /etc/fstab

/dev/sda1 /boot ext4 defaults 0 1
/dev/sda3 /     ext4 defaults 0 1
/dev/sda5 /var  ext4 defaults,nosuid 0 2
/dev/sda6 /home ext4 defaults,nodev 0 2
/dev/sda7 /tmp  ext4 defaults,nosuid,nodev,noexec 0 2

Conclusão 

Um layout de disco bem planejado é fundamental para: 

     Desempenho: Otimização de acesso a dados
     Segurança: Isolamento de componentes críticos
     Manutenção: Facilidade de backup e recuperação
     Escalabilidade: Preparação para crescimento futuro

O conhecimento aprofundado destes conceitos permite criar sistemas robustos e adaptáveis às necessidades específicas de cada ambiente.


That's All Folks!
