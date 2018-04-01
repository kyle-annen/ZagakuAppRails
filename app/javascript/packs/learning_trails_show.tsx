import React from 'react'
import ReactDOM from 'react-dom'

import Container from "./learning_trails/show/container";

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
        <Container title="Topic" />,
        document.body.appendChild(document.createElement('div')),
    )
});