import logging
from datetime import datetime
from unittest import TestCase, mock
from unittest.mock import patch, Mock

from assertpy import assert_that
from populate_dcp_version import find_type_uuid_version, determine_updates, process_path, convert_dcp_version_to_date


class PopulateDcpVersionTest(TestCase):
    def setUp(self) -> None:
        self.version = '2019-05-15T13:54:25.988000Z'
        self.path = f'gs://bucket/prod/no-analysis/metadata/cell_line/uuid_{self.version}.json'
        self.doc = {'_id': 'id'}
        self.date = convert_dcp_version_to_date(self.version)

    def test_find_uuid_version(self):
        # when
        type, uuid, version = find_type_uuid_version(self.path)

        # then
        assert_that(type).is_equal_to('cell_line')
        assert_that(uuid).is_equal_to('uuid')
        assert_that(version).is_equal_to('2019-05-15T13:54:25.988000Z')

    def test_determine_updates(self):
        # given
        doc = {
            '_id': 'id'
        }

        date_obj = datetime.now()
        # when
        updates = determine_updates(doc, date_obj)

        # then
        assert_that(updates).is_equal_to({'dcpVersion': date_obj, 'firstDcpVersion': date_obj})

    def test_determine_updates__only_first_dcp_version(self):
        # given
        another_date = datetime.now()
        doc = {
            '_id': 'id',
            'dcpVersion': another_date
        }

        date_obj = datetime.now()
        # when
        updates = determine_updates(doc, date_obj)

        # then
        assert_that(updates).is_equal_to({'firstDcpVersion': date_obj})

    @patch('populate_dcp_version.find_doc_by_uuid')
    @patch('populate_dcp_version.update_dcp_versions')
    def test_process_metadata_in_line__success(self, mock_update, mock_find):
        mock_find.return_value = self.doc

        logger = logging.getLogger('populate_dcp_version')
        with mock.patch.object(logger, 'error') as mock_error:
            process_path(self.path)
            mock_error.assert_not_called()
            mock_find.assert_called_with('biomaterial', 'uuid')
            mock_update.assert_called_with('biomaterial', self.doc,
                                           {'firstDcpVersion': self.date, 'dcpVersion': self.date})

    @patch('populate_dcp_version.find_doc_by_uuid')
    @patch('populate_dcp_version.update_dcp_versions')
    def test_process_metadata_in_line__error(self, mock_update, mock_find):
        mock_find.return_value = self.doc
        mock_update.side_effect = Exception('mock exception')

        logger = logging.getLogger('populate_dcp_version')
        with mock.patch.object(logger, 'error') as mock_error:
            process_path(self.path)
            mock_error.assert_called()
