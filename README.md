<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![AGPL License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <!-- <a href="https://github.com/lenra-io/template-hello-world-node12">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

<h3 align="center">DevTool</h3>

  <p align="center">
    This repository provides tooling for testing and debugging Lenra applications. Basically, the devtools can easily launch a Lenra App using the same method as the Lenra Server.
    <br />
    <br />
    <!-- <a href="https://github.com/lenra-io/template-hello-world-node12">View Demo</a>
    · -->
    <a href="https://github.com/lenra-io/dev-tools/issues">Report Bug</a>
    ·
    <a href="https://github.com/lenra-io/dev-tools/issues">Request Feature</a>
  </p>
</div>

<!-- GETTING STARTED -->
## Getting Started

### Using Docker Hub

We provide a [docker image](https://hub.docker.com/r/lenra/devtools) on Docker Hub that you can use, it contains everything you need to unlock the full potential of the DevTools. We advise you to not use directly this image but to prefer using the [Lenra CLI](https://github.com/lenra-io/lenra_cli) which can launch the devtools from the command line.

<p align="right">(<a href="#top">back to top</a>)</p>

### Using local docker

You might not want to use the Docker Hub image, if it is the case you can clone this repository and build the docker images following these instructions :

```bash
# Go the the client folder
cd client
# Build flutter web
flutter build web --no-tree-shake-icons
# Go to the root of the repository
cd ..
# Build docker image
docker build -t lenra/devtools:local .
```

You can then use the [Lenra CLI](https://github.com/lenra-io/lenra_cli) to run your application. Just make sure that the `lenra.yml` file contains this specification to use the devtools image that you build in the previous step :

```yml
dev:
  devtool:
    tag: local
```

### Using local environment

To run the devtools locally, not in a Docker container, you can use the following command :

```bash
# Go the the client folder
cd client
# Build flutter web
flutter build web --no-tree-shake-icons
# Copy the generated web folder to the server
cp -r build/web ../server/priv/static
# Go to the server repository
cd ../server
# Setup the server project
mix setup
# Start the server
mix phx.server
```

To update the client, you can use the following command from the client folder :

```bash
# Build flutter web
flutter build web --no-tree-shake-icons
# Copy the generated web folder to the server
cp -r build/web ../server/priv/static
```

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please open an issue with the tag "enhancement" or "bug".
Don't forget to give the project a star! Thanks again!

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the **AGPL** License. See [LICENSE](./LICENSE) for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Lenra - [@lenra_dev](https://twitter.com/lenra_dev) - contact@lenra.io

Project Link: [https://github.com/lenra-io/dev-tools](https://github.com/lenra-io/template-hello-world-node12)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/lenra-io/dev-tools.svg?style=for-the-badge
[contributors-url]: https://github.com/lenra-io/dev-tools/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/lenra-io/dev-tools.svg?style=for-the-badge
[forks-url]: https://github.com/lenra-io/dev-tools/network/members
[stars-shield]: https://img.shields.io/github/stars/lenra-io/dev-tools.svg?style=for-the-badge
[stars-url]: https://github.com/lenra-io/dev-tools/stargazers
[issues-shield]: https://img.shields.io/github/issues/lenra-io/dev-tools.svg?style=for-the-badge
[issues-url]: https://github.com/lenra-io/dev-tools/issues
[license-shield]: https://img.shields.io/github/license/lenra-io/dev-tools.svg?style=for-the-badge
[license-url]: https://github.com/lenra-io/dev-tools/blob/master/LICENSE
