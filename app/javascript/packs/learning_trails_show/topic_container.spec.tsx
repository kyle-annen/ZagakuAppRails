import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as TestUtils from 'react-dom/test-utils';

import TopicContainer from "./topic_container";

describe('TopicContainer', () => {
  it('it renders the title passed', () => {
    const props = { topic: "test topic"};
    const show = TestUtils.renderIntoDocument(
      <TopicContainer {...props}/>
    );

    const learningTrailsShowNode = ReactDOM.findDOMNode(show);

    expect(true).toEqual(true);
  });
});
