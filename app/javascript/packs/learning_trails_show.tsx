import React from 'react'
import ReactDOM from 'react-dom'

import ContentContainer from "./shared/content_container";
import TopicContainer from "./learning_trails_show/topic_container";
import Api from "../utils/api";


document.addEventListener('DOMContentLoaded', () => {
  const data_node = document.getElementById('learning_trails_show_data');
  const data = JSON.parse(data_node.getAttribute('data'));
  const id = data.id;

  ReactDOM.render(
    <ContentContainer title={"Learning Trails"}>
      <TopicContainer id={id} api={new Api}/>
    </ContentContainer>,
    document.body.appendChild(document.createElement('div')),
  )
});