import * as React from 'react'
import * as ReactDOM from 'react-dom'

import ContentContainer from "./shared/content_container";
import TopicContainer from "./learning_trails_show/topic_container";
import TopicApi from "../apis/topic_api";

document.addEventListener('DOMContentLoaded', () => {
  const data_node = document.getElementById('learning_trails_show_data');
  const data = JSON.parse(data_node.getAttribute('data'));
  const id = data.id;

  ReactDOM.render(
    <ContentContainer title={"Learning Trails"}>
      <TopicContainer id={id} api={new TopicApi}/>
    </ContentContainer>,
    document.body.appendChild(document.createElement('div')),
  )
});