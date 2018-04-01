import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as TestUtils from 'react-dom/test-utils';

import Container from "./container";


it('has the header content', () => {
  const props = { title: "test title"}
  const show = TestUtils.renderIntoDocument(
     <Container {...props}/>
  );

  const learningTrailsShowNode = ReactDOM.findDOMNode(show);

  expect(learningTrailsShowNode.textContent).toEqual(props.title);
});