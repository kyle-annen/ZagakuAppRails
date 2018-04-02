import React from 'react'
import ReactDOM from 'react-dom'

import ContentContainer from "./shared/content_container";
import TopicContainer from "./learning_trails_show/topic_container";

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ContentContainer title={"Learning Trails"}>
      <TopicContainer/>
    </ContentContainer>,
    document.body.appendChild(document.createElement('div')),
  )
});