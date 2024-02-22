# Custom Plugin Token Instrospect with Authorization Server using instrospect endpoint.

## 1. Instalación de Kong mediante Helm
### 1.1 Ejecutar el siguiente comando:
```console
# Crear el namespace
kubectl create namespace kong
# Instalar Kong
helm install kong kong/kong --set ingressController.installCRDs=false -n kong --version 2.3.0
```

## 1. Flujo de Integración
El flujo soporta el `Grant Type` `client credentials` de OAuth2.

![Gobierno de APIs-Kong with Keycloak](https://user-images.githubusercontent.com/13005482/224220191-c4b3a64a-486f-40d1-b75c-85024e654965.jpg)


## 2. Despliegue del plugin customizado

### 2.1 Crear configmap

```console
kubectl create configmap kong-plugin-bga-token-instrospection --from-file=src -n kong
```

### 2.2 Actualizar Kong mediante Helm usando el values con los datos del plugin
#### 2.2.1 Datos en Values.yaml
```
# Custom Plugins BGA - From Configmap
plugins:
  configMaps: 
  - name: kong-plugin-bga-token-instrospection
    pluginName: bga-token-instrospection

```

```console
helm upgrade kong kong/kong --set ingressController.installCRDs=false -f valuesdev.yaml -n kong --version 2.3.0

```
`helm upgrade kong kong/kong -n kong -f valuesdev.yaml`


## 3. Configuración


| Form Parameter | default | description |
| --- 						| --- | --- |
| `config.introspection_endpoint`   | | Endpoint de instrospección del servidor de autorización RFC7662 |
| `config.client_id`             |  | Client ID registrado en el servidor de autortización. |
| `config.client_secret`             | 0 | Client Secret del Client ID generado por el servidor de autorización. |
| `config.token_header`             | Authorization | Nombre del Header mediante el cual se obtiene el Access Token. |
| `config.https_verify`             |  | Verificación de HTTPS. |

### 3.1 Códigos HTTP de la validación del Plugin
| Código HTTP | Detalle del Error |
| --- 					| --- |
| `501`                             | Endpoint de instrospección del servidor de autorización RFC7662 |
| `401`                             | Client ID registrado en el servidor de autortización. |
| `config.client_secret`            | Client Secret del Client ID generado por el servidor de autorización. |
| `config.token_header`             | Nombre del Header mediante el cual se obtiene el Access Token. |
| `config.https_verify`             | Verificación de HTTPS. |

### 3.2 Ejemplo de uso del plugin

```html
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: my-token-bga
config:
  introspection_endpoint: "http://192.168.1.5:8082/realms/bga-apps-internas-desarrollo/protocol/openid-connect/token/introspect"
  client_id: "token-validate"
  client_secret: "RTwm9orW4DWWhu7NjtXOJsRFQu736Egm"
  token_header: "Authorization"
  https_verify: false
plugin: bga-token-instrospection
```